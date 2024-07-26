extends CharacterBody2D

const HEALTH_INDICATOR = preload("res://scenes/enemies/health_indicator.tscn")

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var player: CharacterBody2D = %Player
@onready var sprite = $Sprite2D
@onready var nav= $NavigationAgent2D
@onready var behavior_player = $BehaviorPlayer
@onready var animation_player = $AnimationPlayer
@onready var enemy_detection_ray = $EnemyDetectionRay



@export var SPEED : int
@export var HEALTH : int

#State based
enum STATE {IDLE, WANDER, FOLLOW, ATTACK, STAGGER, DYING}
@export var ACTION = STATE.IDLE
var PREV_ACTION = STATE.IDLE

var can_stagger = true
var knockback_speed = Vector2(0, 0)
var health_bar : Node2D = null

var spawn_area : Array
var wander_target : Vector2

func _ready():
	spawn_area.append(Vector2(global_position.x-50, global_position.y-50))
	spawn_area.append(Vector2(global_position.x+50, global_position.y+50))
	behavior_player.play("WANDER")
	
func _physics_process(delta):
	match ACTION:
		STATE.IDLE:
			pass
		STATE.WANDER:
			animation_player.play("WANDER")
			var dir = to_local(nav.get_next_path_position()).normalized()
			if dir.x > 0:
				sprite.scale.x = 1
			elif dir.x < 0:
				sprite.scale.x = -1
			velocity = (dir * SPEED)
			
			if global_position.distance_to(player.global_position) < 80:
				enemy_detection_ray.enabled = true
				enemy_detection_ray.target_position = to_local(player.global_position)
				if enemy_detection_ray.is_colliding():
					if enemy_detection_ray.get_collider().is_in_group("Player"):
						enemy_detection_ray.enabled = false
						enemy_detection_ray.target_position = Vector2(0, 0)
						behavior_player.play("FOLLOW")
			
			
			if nav.distance_to_target() < 5:
				behavior_player.play("WANDER")
			pass
		STATE.FOLLOW:
			animation_player.play("WANDER")
			
			var dir = to_local(nav.get_next_path_position()).normalized()
			if dir.x > 0:
				sprite.scale.x = 1
			elif dir.x < 0:
				sprite.scale.x = -1
			velocity = (dir * SPEED)
			
			if behavior_player.current_animation != "STAGGER":
				behavior_player.play("FOLLOW")
		STATE.STAGGER:
			animation_player.play("STAGGER")
			velocity = Vector2(0, 0)
			if not behavior_player.is_playing():
				ACTION = PREV_ACTION
				match ACTION:
					STATE.IDLE:
						behavior_player.play("WANDER")
					STATE.WANDER:
						behavior_player.play("WANDER")
					STATE.FOLLOW:
						behavior_player.play("FOLLOW")
					#STATE.ATTACK:
						#behavior_player.play("FOLLOW")
	

	velocity += knockback_speed
	move_and_slide()
	if knockback_speed:
		knockback_speed.x = lerp(knockback_speed.x, 0.0, 0.1)
		knockback_speed.y = lerp(knockback_speed.y, 0.0, 0.1)

func take_damage(damage):
	if health_bar == null:
		health_bar = HEALTH_INDICATOR.instantiate()
		health_bar.position = Vector2(0, -(get_child(0).texture.get_size().y))
		add_child(health_bar)

func wander():
	var target_x = randi_range(spawn_area[0].x, spawn_area[1].x)
	var target_y = randi_range(spawn_area[0].y, spawn_area[1].y)
	wander_target = Vector2(target_x, target_y)
	nav.target_position = wander_target
	var dir = to_local(nav.get_next_path_position()).normalized()
	if dir.x > 0:
		sprite.scale.x = 1
	elif dir.x < 0:
		sprite.scale.x = -1
		
func follow():
	wander_target = player.global_position
	nav.target_position = wander_target

func stagger():
	PREV_ACTION = ACTION
	velocity = Vector2(0, 0)
