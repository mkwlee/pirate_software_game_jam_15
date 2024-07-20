extends CharacterBody2D


@onready var player_sprite = $PlayerSprite
@onready var hand_marker = $PlayerSprite/HandMarker
@onready var player_movement_animations = $PlayerMovementAnimations
@onready var player_spell_animations = $PlayerSpellAnimations





@export var SPEED : int = 50

var spell_ready = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
const spells = [preload("res://scenes/spells/earth_spell.tscn"), preload("res://scenes/spells/air_spell.tscn")]

func _ready():
	#player_sprite.self_modulate = Color("#80461B")SS
	pass
	
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash"):
		player_movement_animations.play("player_dash")
	
	velocity = direction*SPEED
	if velocity.x or velocity.y:
		if not player_movement_animations.is_playing():
			player_movement_animations.play("player_walk")
	else:
		player_movement_animations.play("RESET")
	
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	if mouse_direction.x > 0:
		player_sprite.scale.x = 1
	elif mouse_direction.x < 0:
		player_sprite.scale.x = -1
		
	if Input.is_action_pressed("cast_spell_a") and not player_spell_animations.is_playing():
		player_spell_animations.play("cast_earth_spell")
	
	if Input.is_action_pressed("cast_spell_b") and not player_spell_animations.is_playing():
		player_spell_animations.play("cast_air_spell")
	move_and_slide()

func cast_spell(spell_type : int, spell_spawn : Vector2):
	var proj = spells[spell_type].instantiate()
	proj.position = hand_marker.position+spell_spawn
	player_sprite.add_child(proj)
