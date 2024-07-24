extends CharacterBody2D

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var behavior_player: AnimationPlayer = $BehaviorPlayer
@onready var player: CharacterBody2D = %Player
@onready var enemy_detection_ray: RayCast2D = $EnemyDetectionRay


@onready var sprite: Sprite2D = $Sprite2D
@export var SPEED : int
enum STATE {IDLE, WANDER, FOLLOW, ATTACK, STAGGER}
@export var ACTION = STATE.IDLE
var PREV_ACTION = STATE.IDLE

var knockback_speed = Vector2(0, 0)

var spawn_area : Array
var wander_target : Vector2
var can_stagger = true

func _ready() -> void:
	spawn_area.append(Vector2(global_position.x-30, global_position.y-30))
	spawn_area.append(Vector2(global_position.x+30, global_position.y+30))
	behavior_player.play("WANDER")

func _physics_process(delta):
	match ACTION:
		STATE.IDLE:
			velocity = Vector2(0, 0)
			pass
		STATE.WANDER:
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
						behavior_player.play("FOLLOW")
			else:
				enemy_detection_ray.enabled = false
			
			if nav.distance_to_target() < 5:
				behavior_player.play("WANDER")
			pass
			
		STATE.FOLLOW:
			var dir = to_local(nav.get_next_path_position()).normalized()
			if dir.x > 0:
				sprite.scale.x = 1
			elif dir.x < 0:
				sprite.scale.x = -1
			velocity = (dir * SPEED)
			
			if behavior_player.current_animation != "STAGGER":
				if global_position.distance_to(player.global_position) > 120: 
					enemy_detection_ray.enabled = false
					behavior_player.play("WANDER")
				elif global_position.distance_to(player.global_position) < 10:
					behavior_player.play("ATTACK")
				else:
					behavior_player.play("FOLLOW")
			
			#enemy_detection_ray.target_position = to_local(player.global_position)
			#if enemy_detection_ray.is_colliding():
				#if enemy_detection_ray.get_collider().is_in_group("Player"):
					#behavior_player.play("FOLLOW")
				#else:
					#enemy_detection_ray.enabled = false
					#behavior_player.play("WANDER")
			#else:
				#enemy_detection_ray.enabled = false
				#behavior_player.play("WANDER")
			pass
		STATE.ATTACK:
			velocity = Vector2(0, 0)
			pass
		STATE.STAGGER:
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
					STATE.ATTACK:
						behavior_player.play("FOLLOW")
	velocity += knockback_speed
	move_and_slide()
	if knockback_speed:
		knockback_speed.x = lerp(knockback_speed.x, 0.0, 0.1)
		knockback_speed.y = lerp(knockback_speed.y, 0.0, 0.1)

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
