class_name AIPCommunityCreature
extends AIPCreature
## Port of cAICommunity.pas AICommunityCreature - a creature that lives in a
## community and follows boid rules (cohesion / alignment / separation).

var community: AIPCommunity = null


func _act() -> bool:
	if not super._act():
		return false
	if community != null:
		community.update()
		pos.apply_force(community.cohesion(self) + community.alignment(self)
				+ community.separation(self))
	return true


func join_community(comm: AIPCommunity) -> bool:
	if comm != null and comm.admit(self):
		community = comm
		return true
	return false


func leave_community() -> void:
	if community != null:
		community.leave(self)
		community = null


func _on_death() -> void:
	super._on_death()
	leave_community()


func _save_extra(d: Dictionary) -> void:
	super._save_extra(d)
	if community != null:
		d["community_handle"] = community.members[0].handle if not community.members.is_empty() else -1


func _load_extra(d: Dictionary) -> void:
	super._load_extra(d)
