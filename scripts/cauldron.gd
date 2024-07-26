extends Area2D

const CAULDRON_UI = preload("res://scenes/interfaces/cauldron/cauldron_ui.tscn")
@onready var interact_indicator: Node2D = $InteractIndicator


var interactable : bool = false
var in_cauldron = false
var indicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if in_cauldron:
		%GUI.set_spell_slots()
		
	if Input.is_action_just_pressed("interact") and interactable == true:
		in_cauldron = true
		add_child(CAULDRON_UI.instantiate())
		get_tree().paused = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		interactable = true
		interact_indicator.enter_interact()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		interactable = false
		interact_indicator.exit_interact()
