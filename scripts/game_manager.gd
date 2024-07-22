extends Node

var spell_a = 0
var spell_b = 1

# [spell instance, spell animation name]
const spells = [
[preload("res://scenes/spells/earth_spell.tscn"), "cast_earth_spell"], 
[preload("res://scenes/spells/air_spell.tscn"), "cast_air_spell"],
[preload("res://scenes/spells/water_spell.tscn"), "cast_water_spell"],
[preload("res://scenes/spells/fire_spell.tscn"), "cast_fire_spell"]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("dash"):
		spell_a = (spell_a + 1) % 4
		spell_b = (spell_b + 1) % 4
