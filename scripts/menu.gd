extends CanvasLayer

const MAIN_MENU = "res://scenes/main_menu.tscn"

@onready var check_button: CheckButton = $TextureRect/CheckButton
@onready var button: Button = $TextureRect/Button
@onready var button_2: Button = $TextureRect/Button2

var main_menu_from : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_button.button_pressed = GameManager.display_damage
	if main_menu_from:
		button_2.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.display_damage = toggled_on


func _on_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)
