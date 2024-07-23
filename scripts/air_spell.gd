extends CharacterBody2D

@export var DAMAGE : Vector2i
@export var SPEED : int

@export var SHAPE : Global.SPELL_TYPE
@export var MOD : Global.SPELL_TYPE

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("shoot")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	
func shoot_spell():
	change_parent_to_scene()
	rotation = global_position.angle_to_point(get_global_mouse_position())
	var direction = global_position.direction_to(get_global_mouse_position())
	velocity = direction*SPEED

func change_parent_to_scene():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position
