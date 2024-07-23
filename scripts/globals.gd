extends Node


enum SPELL_TYPE {EARTH_SPELL, AIR_SPELL, WATER_SPELL, FIRE_SPELL}

# [spell instance, spell animation name]
const spells = [
[preload("res://scenes/spells/earth_spell.tscn"), "cast_earth_spell", Vector2i(14, 30), 100], 
[preload("res://scenes/spells/air_spell.tscn"), "cast_air_spell", Vector2i(4, 8), 200],
[preload("res://scenes/spells/water_spell.tscn"), "cast_water_spell", Vector2i(6, 12), 50],
[preload("res://scenes/spells/fire_spell.tscn"), "cast_fire_spell", Vector2i(10, 16), 150]
]

const spell_colors = [
	Color("#80461b"), 
	Color("#848884"),
	Color("#6082b6"),
	Color("#de3163")
]

const spell_icons = [
	preload("res://assets/sprites/UI/spells/earth_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/air_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/water_spell_slot.png"),
	preload("res://assets/sprites/UI/spells/fire_spell_slot.png")
]
