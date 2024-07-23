extends CharacterBody2D

var knockback_friction : float
const DAMAGE_INDICATOR = preload("res://scenes/enemies/damage_indicator.tscn")

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, knockback_friction*delta)
	velocity.y = move_toward(velocity.y, 0, knockback_friction*delta)
	knockback_friction *= 1+(0.2*delta)
	move_and_slide()

func take_damage(damage : int):
	
	var dmg = DAMAGE_INDICATOR.instantiate()
	dmg.position = Vector2(randi_range(-8, 8), randi_range(-8, 8))
	dmg.get_child(0).text = str(damage)
	add_child(dmg)
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("take_damage")

func push_position(direction, speed):
	velocity += direction*speed
	knockback_friction = speed*2.5
