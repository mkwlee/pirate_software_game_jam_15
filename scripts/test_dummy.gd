extends CharacterBody2D

var knockback_friction : float

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, knockback_friction*delta)
	velocity.y = move_toward(velocity.y, 0, knockback_friction*delta)
	move_and_slide()

func take_damage(knock_back : Vector2, persist):
	if knock_back:
		velocity += knock_back
		if not persist:
			knockback_friction = knock_back.length()
	$AnimationPlayer.play("take_damage")
