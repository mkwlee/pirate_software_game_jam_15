extends Area2D

var interactable : bool = false
var in_cauldron = false
const CAULDRON_UI = preload("res://scenes/interfaces/cauldron/cauldron_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_cauldron:
		%GUI.set_spell_slots()
		
	if Input.is_action_just_pressed("interact") and interactable == true:
		in_cauldron = true
		add_child(CAULDRON_UI.instantiate())
		get_tree().paused = true



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		interactable = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		interactable = false
