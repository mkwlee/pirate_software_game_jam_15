extends Node

#Determines (Spell, Mod) : (SPELL_TYPE, SPELL_TYPE)
# Mod = -1 means no mod
var spell_a : Vector2i = Vector2i(-1, -1)
var spell_b : Vector2i = Vector2i(-1, -1)


var display_damage = true
var unlocked_spells = [1, 1, 1, 1]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	
