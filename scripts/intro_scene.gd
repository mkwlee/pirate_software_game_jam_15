extends Control
const TUTORIAL_LEVEL = preload("res://scenes/world/tutorial_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func next_scene():
	get_tree().change_scene_to_packed(TUTORIAL_LEVEL)

