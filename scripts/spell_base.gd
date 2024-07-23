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
	if SHAPE == Global.SPELL_TYPE.AIR_SPELL:
		velocity = direction*SPEED*2
	elif MOD == Global.SPELL_TYPE.AIR_SPELL:
		velocity = direction*SPEED*1.5
	else:
		velocity = direction*SPEED
		
	if SHAPE == Global.SPELL_TYPE.WATER_SPELL:
		pass
	elif MOD == Global.SPELL_TYPE.WATER_SPELL:
		call_deferred("set_water_mod_timer")


func change_parent_to_scene():
	var current_position = global_position
	var current_scene = get_tree().current_scene
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = current_position

func set_water_mod_timer():
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
