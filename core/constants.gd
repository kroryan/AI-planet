class_name AIP
## AI Planet Remaster - global constants, kind table and tuning.
## Port of cGlobals.pas / cAIThings.pas kind table (GPL-2.0, ai.planet by Dave Kerr).

enum Kind {
	APPLE, ORANGE, APPLE_TREE, ORANGE_TREE, APPLE_SEED, ORANGE_SEED,
	BIRD, FISH, DUCK, CRAB, HAWK, TURTLE, CLOUD, ICEBERG, LADYBUG, ANT,
	SUN, MOON, COMMUNITY, ASTEROID, SHARK, AQUA_PLANT, BOT, EXPLOSION,
	FLOCK, BALL, BOMB, GRAZER, TREX, VIBE, WEAPON, LIGHTNING, BEACON,
	TERRIER, FOX, RABBIT, GRASS, MOUSE, TIGER, DOLPHIN, EARTHQUAKE,
	EVOLVING_TREE, EVOLVING_FRUIT, EVOLVING_SEED, FIRE_TREE, SPEECH,
	MISSILE_DEFENCE, MISSILE,
}

const KIND_COUNT := 48
const VERSION := 1000
const TICKS_PER_SECOND := 25.0
const CELL_SIZE := 10.0

const GRAVITY := -0.08
const AIR_FRICTION := 0.995
const LAND_FRICTION := 0.90
const WATER_FRICTION := 0.93

const MAX_HEALTH := 1024.0
const ROT_TICKS := 512
const MATING_BABY_TICKS := 1024
const MATING_ADULT_TICKS := 9500
const MATING_ELDER_TICKS := 10000
const MATING_COOLDOWN := 128
const BIRTH_COST := 512.0
const GRASS_SPREAD_TICKS := 128
const CLOUD_LIFESPAN := 2048
const SURFACE_TENSION := 0.25
const METEOR_INTERVAL := 128

enum Binding { AIR, LAND, WATER, SPACE }
enum LandState { DESERT, DIRT, FIELD, GRASS, POND, LAKE, SEA, OCEAN, SNOW, ROCK }

enum Desire { NONE, WANDER, FOOD, MATE, EAT, LAND, RETIRE, PLAY, DRINK }

const LAND_STATE_NAMES := {
	LandState.DESERT: "Desert", LandState.DIRT: "Dirt", LandState.FIELD: "Field",
	LandState.GRASS: "Grass", LandState.POND: "Pond", LandState.LAKE: "Lake",
	LandState.SEA: "Sea", LandState.OCEAN: "Ocean", LandState.SNOW: "Snow",
	LandState.ROCK: "Rock",
}

const SPECIES := {
	Kind.APPLE: {"name": "Apple", "max": 2000, "model": "fruit", "scale": 0.35, "food": 64.0},
	Kind.ORANGE: {"name": "Orange", "max": 2000, "model": "fruit2", "scale": 0.35, "food": 64.0},
	Kind.APPLE_TREE: {"name": "Apple Tree", "max": 500, "model": "appletree", "scale": 1.0, "food": 128.0},
	Kind.ORANGE_TREE: {"name": "Orange Tree", "max": 500, "model": "orangetree", "scale": 1.0, "food": 128.0},
	Kind.APPLE_SEED: {"name": "Apple Seed", "max": 2000, "model": "seed", "scale": 0.2, "food": 8.0},
	Kind.ORANGE_SEED: {"name": "Orange Seed", "max": 2000, "model": "seed", "scale": 0.2, "food": 8.0},
	Kind.BIRD: {"name": "Bird", "max": 500, "model": "bird", "scale": 0.6, "habitat": "air", "speed": 0.9, "prey": [Kind.APPLE, Kind.ORANGE]},
	Kind.FISH: {"name": "Fish", "max": 1000, "model": "fish", "scale": 0.6, "habitat": "water", "speed": 0.7, "prey": [Kind.APPLE_SEED, Kind.ORANGE_SEED, Kind.AQUA_PLANT], "meat": 256.0},
	Kind.DUCK: {"name": "Duck", "max": 500, "model": "duck", "scale": 0.7, "habitat": "water", "speed": 0.5, "prey": [Kind.APPLE, Kind.ORANGE, Kind.GRASS], "meat": 256.0},
	Kind.CRAB: {"name": "Crab", "max": 500, "model": "crab", "scale": 0.5, "habitat": "land", "speed": 0.3, "prey": [Kind.APPLE, Kind.ORANGE], "meat": 128.0},
	Kind.HAWK: {"name": "Hawk", "max": 100, "model": "hawk", "scale": 0.8, "habitat": "air", "speed": 1.3, "prey": [Kind.BIRD, Kind.RABBIT, Kind.MOUSE, Kind.LADYBUG], "meat": 512.0},
	Kind.TURTLE: {"name": "Turtle", "max": 300, "model": "turtle", "scale": 0.6, "habitat": "water", "speed": 0.2, "prey": [Kind.APPLE, Kind.ORANGE, Kind.AQUA_PLANT], "meat": 256.0},
	Kind.CLOUD: {"name": "Cloud", "max": 200, "model": "cloud", "scale": 2.0, "intangible": true},
	Kind.ICEBERG: {"name": "Iceberg", "max": 100, "model": "iceberg", "scale": 1.5},
	Kind.LADYBUG: {"name": "Ladybug", "max": 2000, "model": "ladybug", "scale": 0.25, "habitat": "land", "speed": 0.25, "prey": [Kind.GRASS], "meat": 32.0},
	Kind.ANT: {"name": "Ant", "max": 2000, "model": "ant", "scale": 0.2, "habitat": "land", "speed": 0.2, "prey": [Kind.GRASS], "meat": 16.0},
	Kind.SUN: {"name": "Sun", "max": 2, "model": "point", "scale": 6.0, "intangible": true},
	Kind.MOON: {"name": "Moon", "max": 2, "model": "point", "scale": 4.0, "intangible": true},
	Kind.COMMUNITY: {"name": "Community", "max": 500, "invisible": true},
	Kind.ASTEROID: {"name": "Asteroid", "max": 200, "model": "asteroid", "scale": 0.8},
	Kind.SHARK: {"name": "Shark", "max": 100, "model": "shark", "scale": 0.9, "habitat": "water", "speed": 1.0, "prey": [Kind.FISH, Kind.DUCK, Kind.TURTLE], "meat": 768.0},
	Kind.AQUA_PLANT: {"name": "Water Plant", "max": 2000, "model": "aquaplant", "scale": 0.5, "food": 64.0},
	Kind.BOT: {"name": "Bot", "max": 50, "model": "bot", "scale": 0.7, "habitat": "air", "speed": 0.8, "meat": 512.0},
	Kind.EXPLOSION: {"name": "Explosion", "max": 400, "invisible": true},
	Kind.FLOCK: {"name": "Flock", "max": 200, "invisible": true},
	Kind.BALL: {"name": "Ball", "max": 200, "model": "beachball", "scale": 0.5},
	Kind.BOMB: {"name": "Bomb", "max": 200, "model": "dynamite", "scale": 0.4},
	Kind.GRAZER: {"name": "Grazer", "max": 500, "model": "grazer", "scale": 0.8, "habitat": "land", "speed": 0.4, "prey": [Kind.GRASS], "meat": 384.0},
	Kind.TREX: {"name": "T-Rex", "max": 20, "model": "tyranno", "scale": 1.6, "habitat": "land", "speed": 0.7, "prey": [Kind.RABBIT, Kind.FOX, Kind.GRAZER, Kind.TERRIER], "meat": 1024.0},
	Kind.VIBE: {"name": "Vibe", "max": 200, "invisible": true},
	Kind.WEAPON: {"name": "Weapon", "max": 100, "model": "weapon", "scale": 0.5},
	Kind.LIGHTNING: {"name": "Lightning", "max": 100, "invisible": true},
	Kind.BEACON: {"name": "Beacon", "max": 100, "model": "beacon", "scale": 0.8},
	Kind.TERRIER: {"name": "Terrier", "max": 100, "model": "terrier", "scale": 0.7, "habitat": "land", "speed": 0.8, "prey": [Kind.RABBIT, Kind.FOX, Kind.MOUSE], "meat": 384.0},
	Kind.FOX: {"name": "Fox", "max": 300, "model": "fox", "scale": 0.7, "habitat": "land", "speed": 0.8, "prey": [Kind.RABBIT, Kind.MOUSE, Kind.LADYBUG, Kind.BIRD], "meat": 512.0},
	Kind.RABBIT: {"name": "Rabbit", "max": 5000, "model": "rabbit", "scale": 0.4, "habitat": "land", "speed": 0.7, "prey": [Kind.GRASS, Kind.APPLE, Kind.ORANGE], "meat": 128.0},
	Kind.GRASS: {"name": "Grass", "max": 20000, "model": "grassblade", "scale": 0.3, "food": 16.0},
	Kind.MOUSE: {"name": "Mouse", "max": 1000, "model": "mouse", "scale": 0.3, "habitat": "land", "speed": 0.5, "prey": [Kind.GRASS, Kind.APPLE_SEED, Kind.ORANGE_SEED], "meat": 64.0},
	Kind.TIGER: {"name": "Tiger", "max": 50, "model": "tiger", "scale": 1.2, "habitat": "land", "speed": 0.9, "prey": [Kind.RABBIT, Kind.FOX, Kind.GRAZER, Kind.TERRIER], "meat": 896.0},
	Kind.DOLPHIN: {"name": "Dolphin", "max": 200, "model": "dolphin1", "scale": 0.9, "habitat": "water", "speed": 1.1, "prey": [Kind.FISH], "meat": 640.0},
	Kind.EARTHQUAKE: {"name": "Earthquake", "max": 50, "invisible": true},
	Kind.EVOLVING_TREE: {"name": "Evolving Tree", "max": 500, "model": "newtree", "scale": 1.0},
	Kind.EVOLVING_FRUIT: {"name": "Evolving Fruit", "max": 2000, "model": "fruit", "scale": 0.35, "food": 64.0},
	Kind.EVOLVING_SEED: {"name": "Evolving Seed", "max": 2000, "model": "seed", "scale": 0.2, "food": 8.0},
	Kind.FIRE_TREE: {"name": "Forest Tree", "max": 1000, "model": "newtree", "scale": 1.0},
	Kind.SPEECH: {"name": "Speech", "max": 400, "invisible": true},
	Kind.MISSILE_DEFENCE: {"name": "Missile Defence", "max": 20, "model": "defence", "scale": 0.8, "intangible": true},
	Kind.MISSILE: {"name": "Missile", "max": 200, "model": "satellite", "scale": 0.3},
}
