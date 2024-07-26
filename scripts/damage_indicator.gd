extends Node2D
@onready var label = $Label
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready()  -> void:
	position = Vector2(randi_range(-8, 8), randi_range(-8, 8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	
func run_indicator(damage : int) -> void:
	label.text = str(damage)
	#animation_player.play("RESET")
	animation_player.play("display_damage")
