extends Area2D
@onready var gpu_particles_2d = $GPUParticles2D

var velocity : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("air_spell_shoot")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta

func shoot_spell():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position
	var test = rad_to_deg(global_position.angle_to_point(get_global_mouse_position())) / 90
	#print(roundi(test)+1)
	rotation_degrees = -90 + ((roundi(test)+1)*90)
	velocity = global_position.direction_to(get_global_mouse_position())*200
	gpu_particles_2d.emitting = true


func _on_body_entered(body):
	queue_free()
