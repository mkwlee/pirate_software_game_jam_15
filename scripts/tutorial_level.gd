extends Node2D

const MAIN_MENU = "res://scenes/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, GameManager.unlocked_spells.size()):
		GameManager.unlocked_spells[x] = 0
	GameManager.spell_a.x = -1
	GameManager.spell_a.y = -1
	GameManager.spell_b.x = -1
	GameManager.spell_b.y = -1
	get_tree().current_scene.find_child("GUI").set_spell_slots()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		get_tree().change_scene_to_file(MAIN_MENU)
