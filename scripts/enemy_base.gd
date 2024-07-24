extends CharacterBody2D

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var player: CharacterBody2D = %Player



@export var SPEED : int
var can_stagger = false
var knockback_speed = Vector2(0, 0)

func _physics_process(delta):

	velocity = knockback_speed
	move_and_slide()
	if knockback_speed:
		knockback_speed.x = lerp(knockback_speed.x, 0.0, 0.1)
		knockback_speed.y = lerp(knockback_speed.y, 0.0, 0.1)
