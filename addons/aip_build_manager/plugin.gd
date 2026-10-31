@tool
extends EditorPlugin
## AIP Build Manager - one-click release builds for AI Planet Remaster.
## Modeled on hrh_build_manager (same author's toolkit), simplified for a
## GPL project: no PCK encryption, no obfuscation - source stays open.

const TARGETS := [
	{"id": "linux", "label": "Linux", "preset": "Linux", "out": "build/linux/AIPlanetRemaster.x86_64"},
	{"id": "windows", "label": "Windows", "preset": "Windows Desktop", "out": "build/windows/AIPlanetRemaster.exe"},
	{"id": "android_apk", "label": "Android APK", "preset": "Android", "out": "build/android/AIPlanetRemaster.apk"},
	{"id": "android_aab", "label": "Android AAB (Play)", "preset": "Android AAB", "out": "build/android/AIPlanetRemaster.aab"},
]

const CACHE_PATH := "res://.godot/build-manager-cache.json"
const CRED_DIR := "res://.godot/private-build-credentials"

var dock: Control
var checkboxes := {}
var version_name_edit: LineEdit
var version_code_spin: SpinBox
var log_view: RichTextLabel
var progress: ProgressBar
var _thread: Thread = null
var _building := false


func _enter_tree() -> void:
	dock = _build_dock()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)


func _exit_tree() -> void:
	if dock != null:
		remove_control_from_docks(dock)
		dock.queue_free()
	if _thread != null and _thread.is_alive():
		_thread.wait_to_finish()


func _build_dock() -> Control:
	var root := PanelContainer.new()
	root.name = "AIPBuildManager"
	root.custom_minimum_size = Vector2(320, 0)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	root.add_child(box)
	var title := Label.new()
	title.text = "AI Planet Remaster - release builds"
	title.add_theme_font_size_override("font_size", 15)
	box.add_child(title)
	for target in TARGETS:
		var row := HBoxContainer.new()
		var cb := CheckBox.new()
		cb.text = target["label"]
		cb.button_pressed = target["id"] in ["linux", "windows"]
		checkboxes[target["id"]] = {"check": cb}
		row.add_child(cb)
		var status := Label.new()
		status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		status.add_theme_font_size_override("font_size", 12)
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		checkboxes[target["id"]]["status"] = status
		row.add_child(status)
		box.add_child(row)
	var version_row := HBoxContainer.new()
	var vlabel := Label.new()
	vlabel.text = "Android version:"
	version_row.add_child(vlabel)
	version_name_edit = LineEdit.new()
	version_name_edit.text = "1.0.0"
	version_name_edit.custom_minimum_size = Vector2(80, 0)
	version_row.add_child(version_name_edit)
	version_code_spin = SpinBox.new()
	version_code_spin.min_value = 1
	version_code_spin.max_value = 2100000000
	version_code_spin.value = 1
	version_row.add_child(version_code_spin)
	box.add_child(version_row)
	var build_btn := Button.new()
	build_btn.text = "BUILD SELECTED"
	build_btn.custom_minimum_size = Vector2(0, 44)
	build_btn.pressed.connect(_on_build)
	box.add_child(build_btn)
	var open_btn := Button.new()
	open_btn.text = "Open build folder"
	open_btn.pressed.connect(func(): OS.shell_open(ProjectSettings.globalize_path("res://build/")))
	box.add_child(open_btn)
	progress = ProgressBar.new()
	progress.show_percentage = false
	box.add_child(progress)
	log_view = RichTextLabel.new()
	log_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_view.scroll_following = true
	log_view.custom_minimum_size = Vector2(0, 220)
	box.add_child(log_view)
	var note := Label.new()
	note.text = "MSIX (Microsoft Store): use the GitHub Actions workflow (.github/workflows/build-release.yml) or MakeAppx on Windows.\nKeystore: place ai-planet-upload.keystore + keystore.properties in the project root (never committed)."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_font_size_override("font_size", 12)
	box.add_child(note)
	_load_cache()
	_refresh_status()
	return root


func _refresh_status() -> void:
	var presets := _preset_names()
	for target in TARGETS:
		var status: Label = checkboxes[target["id"]]["status"]
		if not presets.has(target["preset"]):
			status.text = "No preset"
		elif target["id"].begins_with("android"):
			var sdk := _editor_setting("export/android/android_sdk_path")
			var jdk := _editor_setting("export/android/java_sdk_path")
			if sdk == "" or jdk == "":
				status.text = "Set Android SDK/JDK in Editor Settings"
			elif not _templates_installed():
				status.text = "Install export templates"
			else:
				status.text = "Ready"
		elif not _templates_installed():
			status.text = "Install export templates"
		else:
			status.text = "Ready"


func _preset_names() -> Array:
	var cfg := ConfigFile.new()
	var result := []
	if cfg.load("res://export_presets.cfg") == OK:
		for section in cfg.get_sections():
			if section.begins_with("preset.") and not section.ends_with(".options"):
				result.push_back(cfg.get_value(section, "name"))
	return result


func _editor_setting(key: String) -> String:
	var editor := EditorInterface
	var settings = editor.get_editor_settings()
	return str(settings.get_setting(key)) if settings.has_setting(key) else ""


func _templates_installed() -> bool:
	var version := "%s.%s.%s" % [Engine.get_version_info()["major"],
			Engine.get_version_info()["minor"], Engine.get_version_info()["status"]]
	var base := OS.get_environment("HOME") + "/.local/share/godot/export_templates/" \
			if OS.get_name() != "Windows" else \
			OS.get_environment("APPDATA").path_join("../Roaming/Godot/export_templates/")
	var dir := DirAccess.open(base + version)
	return dir != null


func _log(text: String) -> void:
	log_view.append_text(_redact(text) + "\n")


func _redact(text: String) -> String:
	var result := text
	for secret in ["storePassword", "keyPassword", "keystore/release_password"]:
		if ":" in result and secret in result:
			result = result.split(":")[0] + ": [REDACTED]"
	return result


func _on_build() -> void:
	if _building:
		return
	var selected := []
	for target in TARGETS:
		var cb: CheckBox = checkboxes[target["id"]]["check"]
		if cb.button_pressed:
			selected.push_back(target)
	if selected.is_empty():
		_log("Nothing selected.")
		return
	_save_cache()
	_building = true
	progress.value = 0.0
	_thread = Thread.new()
	_thread.start(_run_builds.bind(selected))


func _run_builds(selected: Array) -> void:
	var report := {"started": Time.get_unix_time_from_system(), "artifacts": []}
	var godot := OS.get_executable_path()
	var project := ProjectSettings.globalize_path("res://")
	_prepare_signing()
	_ensure_android_libs(selected)
	var version_name := str(version_name_edit.text)
	var version_code := int(version_code_spin.value)
	var original := FileAccess.get_file_as_string("res://export_presets.cfg")
	var patched := _patch_android_versions(original, version_name, version_code)
	if patched != original:
		FileAccess.open("res://export_presets.cfg", FileAccess.WRITE).store_string(patched)
	for target in selected:
		var out_path: String = ProjectSettings.globalize_path("res://") + target["out"]
		DirAccess.make_dir_recursive_absolute(out_path.get_base_dir())
		var args := ["--headless", "--path", project, "--export-release", target["preset"], out_path]
		_log("Exporting " + target["label"] + " ...")
		var output := []
		var exit_code := OS.execute(godot, args, output, true)
		for line in output:
			_log(str(line))
		if exit_code != 0 or not FileAccess.file_exists(out_path):
			_log("FAILED: " + target["label"])
			report["artifacts"].push_back({"target": target["id"], "ok": false})
		else:
			var sha := FileAccess.get_sha256(out_path)
			var size := FileAccess.get_file_as_string(out_path).length()
			var f := FileAccess.open(out_path, FileAccess.READ)
			size = f.get_length()
			f.close()
			_log("OK: " + target["out"] + " (" + String.humanize_size(size) + ") sha256=" + sha.substr(0, 16) + "…")
			report["artifacts"].push_back({"target": target["id"], "ok": true,
					"path": target["out"], "sha256": sha, "bytes": size})
		progress.value += 100.0 / selected.size()
	if patched != original:
		FileAccess.open("res://export_presets.cfg", FileAccess.WRITE).store_string(original)
	report["finished"] = Time.get_unix_time_from_system()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://build"))
	var report_file := FileAccess.open("res://build/build-report.json", FileAccess.WRITE)
	report_file.store_string(JSON.stringify(report, "\t"))
	report_file.close()
	_log("Report: build/build-report.json")
	_building = false


func _ensure_android_libs(selected: Array) -> void:
	var needs_android := false
	for target in selected:
		if str(target["id"]).begins_with("android"):
			needs_android = true
	if not needs_android:
		return
	var version := "%s.%s.%s" % [Engine.get_version_info()["major"],
			Engine.get_version_info()["minor"], Engine.get_version_info()["status"]]
	var base := OS.get_environment("HOME") + "/.local/share/godot/export_templates/" \
			if OS.get_name() != "Windows" else \
			OS.get_environment("APPDATA").path_join("Godot/export_templates/")
	var template_dir := base + version + "/android_source.zip"
	for flavor in ["debug", "release"]:
		var name := "godot-lib.template_%s.aar" % flavor
		var dest := ProjectSettings.globalize_path("res://android/build/libs/%s/%s" % [flavor, name])
		if FileAccess.file_exists(dest):
			continue
		var src := _extract_aar_from_zip(template_dir, name)
		if src != "":
			DirAccess.make_dir_recursive_absolute(dest.get_base_dir())
			var dir := DirAccess.open("res://")
			dir.copy_absolute(src, dest)
			_log("Restored " + name + " from export templates.")
		else:
			_log("WARNING: " + name + " missing - reinstall the Android build template (Project menu).")


func _extract_aar_from_zip(zip_path: String, aar_name: String) -> String:
	if not FileAccess.file_exists(zip_path):
		return ""
	var reader := ZIPReader.new()
	if reader.open(zip_path) != OK:
		return ""
	for path in reader.get_files():
		if path.get_file() == aar_name:
			var target := OS.get_user_data_dir() + "/tmp_" + aar_name
			var f := FileAccess.open(target, FileAccess.WRITE)
			f.store_buffer(reader.read_file(path))
			f.close()
			reader.close()
			return target
	reader.close()
	return ""


func _prepare_signing() -> void:
	if not FileAccess.file_exists("res://keystore.properties"):
		return
	if not FileAccess.file_exists("res://ai-planet-upload.keystore"):
		_log("keystore.properties found but ai-planet-upload.keystore missing")
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(CRED_DIR))
	var dir := DirAccess.open("res://")
	dir.copy_absolute(ProjectSettings.globalize_path("res://ai-planet-upload.keystore"),
			ProjectSettings.globalize_path(CRED_DIR + "/ai-planet-upload.keystore"))
	var props := FileAccess.get_file_as_string("res://keystore.properties")
	var store_password := ""
	for line in props.split("\n"):
		if line.begins_with("storePassword="):
			store_password = line.trim_prefix("storePassword=").strip_edges()
	OS.set_environment("GODOT_ANDROID_KEYSTORE_RELEASE_PATH",
			ProjectSettings.globalize_path(CRED_DIR + "/ai-planet-upload.keystore"))
	OS.set_environment("GODOT_ANDROID_KEYSTORE_RELEASE_USER", "aiplanet_upload")
	OS.set_environment("GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD", store_password)
	_log("Release keystore staged for Android builds.")


func _patch_android_versions(text: String, version_name: String, version_code: int) -> String:
	var result := text
	result = result.replace("version/code=1", "version/code=" + str(version_code))
	result = result.replace('version/name="1.0.0"', 'version/name="' + version_name + '"')
	return result


func _load_cache() -> void:
	var f := FileAccess.open(CACHE_PATH, FileAccess.READ)
	if f == null:
		return
	var data = JSON.parse_string(f.get_as_text())
	f.close()
	if data is Dictionary:
		version_name_edit.text = data.get("version_name", "1.0.0")
		version_code_spin.value = int(data.get("version_code", 1))


func _save_cache() -> void:
	DirAccess.make_dir_recursive_absolute("res://.godot")
	var f := FileAccess.open(CACHE_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify({"version_name": version_name_edit.text,
				"version_code": int(version_code_spin.value)}))
		f.close()
