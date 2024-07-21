extends CharacterBody2D

var attack_in_progress = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("earth_spell_charge")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("Enemy"):
			collider.take_damage()
		queue_free()

func shoot_spell():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position
	velocity = global_position.direction_to(get_global_mouse_position())*50
	$GPUParticles2D.emitting = true
