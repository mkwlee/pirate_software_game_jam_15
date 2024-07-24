extends CharacterBody2D

var knockback_friction : float
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, knockback_friction*delta)
	velocity.y = move_toward(velocity.y, 0, knockback_friction*delta)
	knockback_friction *= 1+(0.2*delta)
	move_and_slide()
