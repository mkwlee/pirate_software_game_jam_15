extends Area2D

var velocity : Vector2
var attack_in_progress = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("earth_spell_charge")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta

func shoot_spell():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position
	velocity = global_position.direction_to(get_global_mouse_position())*50
	$GPUParticles2D.emitting = true
	
func _on_body_entered(body):
	queue_free()
