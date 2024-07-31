extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for spell in GameManager.unlocked_spells:
		spell = 0
