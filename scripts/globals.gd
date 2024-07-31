extends Node


enum SPELL_TYPE {EARTH_SPELL, AIR_SPELL, WATER_SPELL, FIRE_SPELL}

# [spell instance, spell animation name]
const spells = [
[preload("res://scenes/spells/earth_spell.tscn"), "cast_earth_spell", Vector2i(14, 20), 100], 
[preload("res://scenes/spells/air_spell.tscn"), "cast_air_spell", Vector2i(2, 4), 200],
[preload("res://scenes/spells/water_spell.tscn"), "cast_water_spell", Vector2i(6, 10), 50],
[preload("res://scenes/spells/fire_spell.tscn"), "cast_fire_spell", Vector2i(8, 12), 150]
]

const spell_colors = [
	Color("#80461b"), 
	Color("#8A9A5B"),
	Color("#6082b6"),
	Color("#de3163")
]

const spell_icons = [
	preload("res://assets/sprites/UI/spells/earth_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/air_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/water_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/fire_spell_slot.png")
]


const spell_descriptions = [
	"Earth Spell. Charge and launch a boulder of the earth, dealing damage to the target and knocking them back.",
	"Air Spell. Summon three slices of air that burst with speed, dealing damage to the target.",
	"Water Spell. Create a wave of water that crashes forward, dealing damage to any target in its path.",
	"Fire Spell. Cast a bolt of fire, dealing damage and exploding with damage to any other targets it hits."
]

const mod_descriptions = [
	"Earth Mod. Spell deals knockback on target hit.",
	"Air Mod. Spell travel speed is increased.",
	"Water Mod. Spell persists through the target.",
	"Fire Mod. Spell creates an explosion on target hit."
]
