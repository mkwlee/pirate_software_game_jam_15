extends CharacterBody2D


@onready var player_sprite = $PlayerSprite
@onready var hand_marker = $PlayerSprite/HandMarker
@onready var player_movement_animations = $PlayerMovementAnimations
@onready var player_spell_animations = $PlayerSpellAnimations


@export var SPEED : int = 50

var current_spell

func _ready():
	#player_sprite.self_modulate = Color("#80461B")
	pass
	
func _physics_process(delta):
	
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped():
		player_spell_animations.stop()
		player_movement_animations.play("player_dash")
	velocity = direction*SPEED
	move_and_slide()
	
	#Animation WALK or IDLE
	if velocity.x or velocity.y:
		if not player_movement_animations.is_playing():
			player_movement_animations.play("player_walk")
	else:
		player_movement_animations.play("RESET")
	
	#Look LEFT or RIGHT at MOUSE
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	if mouse_direction.x > 0:
		player_sprite.scale.x = 1
	elif mouse_direction.x < 0:
		player_sprite.scale.x = -1
	
	# Cast SPELL A
	if Input.is_action_pressed("cast_spell_a") and not player_spell_animations.is_playing():
		current_spell = GameManager.spell_a
		player_spell_animations.play(Global.spells[GameManager.spell_a.x][1])
	
	# Cast SPELL B
	if Input.is_action_pressed("cast_spell_b") and not player_spell_animations.is_playing():
		current_spell = GameManager.spell_b
		player_spell_animations.play(Global.spells[GameManager.spell_b.x][1])

func cast_spell(spell_spawn : Vector2):
	var proj = Global.spells[current_spell.x][0].instantiate()
	proj.position = hand_marker.position+spell_spawn
	proj.SHAPE = current_spell.x
	proj.MOD = current_spell.y
	proj.DAMAGE = Global.spells[current_spell.x][2]
	proj.SPEED = Global.spells[current_spell.x][3]
	proj.modulate = Global.spell_colors[current_spell.y]
	player_sprite.add_child(proj)
	if current_spell == GameManager.spell_a:
		%GUI.set_spell_cooldown(0, player_spell_animations.current_animation_length)
	elif current_spell == GameManager.spell_b:
		%GUI.set_spell_cooldown(1, player_spell_animations.current_animation_length)
