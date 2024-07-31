extends Control

const INTRO_SCENE = preload("res://scenes/world/intro_scene.tscn")
const ARENA_LEVEL = preload("res://scenes/world/arena_level.tscn")
const MENU = preload("res://scenes/interfaces/menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_packed(INTRO_SCENE)


func _on_arena_button_pressed() -> void:
	get_tree().change_scene_to_packed(ARENA_LEVEL)


func _on_options_button_pressed() -> void:
	var esc_menu = MENU.instantiate()
	esc_menu.main_menu_from = true
	get_tree().current_scene.add_child(esc_menu)
	get_tree().paused = true
