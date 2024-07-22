extends CharacterBody2D

@export var DAMAGE : Vector2i
@export var SPEED : int

@export var KNOCKBACK : bool = false
@export var PERSIST : bool = false
@export var EXPLODE : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("air_spell_shoot")


func _physics_process(delta):
	move_and_slide()
		
func shoot_spell():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position
	var test = rad_to_deg(global_position.angle_to_point(get_global_mouse_position())) / 90
	rotation = global_position.angle_to_point(get_global_mouse_position())
	velocity = global_position.direction_to(get_global_mouse_position())*SPEED
