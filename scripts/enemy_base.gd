extends CharacterBody2D

const HEALTH_INDICATOR = preload("res://scenes/enemies/health_indicator.tscn")

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var player: CharacterBody2D = %Player



@export var SPEED : int
@export var HEALTH : int

var can_stagger = false
var knockback_speed = Vector2(0, 0)
var health_bar : Node2D = null

func _physics_process(_delta) -> void:

	velocity = knockback_speed
	move_and_slide()
	if knockback_speed:
		knockback_speed.x = lerp(knockback_speed.x, 0.0, 0.1)
		knockback_speed.y = lerp(knockback_speed.y, 0.0, 0.1)

func take_damage(_damage) -> void:
	if health_bar == null:
		health_bar = HEALTH_INDICATOR.instantiate()
		health_bar.position = Vector2(0, -(get_child(0).texture.get_size().y))
		add_child(health_bar)
