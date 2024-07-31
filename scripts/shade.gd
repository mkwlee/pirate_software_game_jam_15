extends CharacterBody2D

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var behavior_player: AnimationPlayer = $BehaviorPlayer
@onready var player: CharacterBody2D
@onready var enemy_detection_ray: RayCast2D = $EnemyDetectionRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var enemy_hurt_box = $Sprite2D/EnemyHurtBox


const HEALTH_INDICATOR = preload("res://scenes/enemies/health_indicator.tscn")

#Stats
@export var SPEED : int
@export var HEALTH : int


#State based
enum STATE {IDLE, WANDER, FOLLOW, ATTACK, STAGGER, DYING}
@export var ACTION = STATE.IDLE
var PREV_ACTION = STATE.IDLE

#Universal
var knockback_speed = Vector2(0, 0)
var can_stagger = true
var health_bar : Node2D = null

#Shade Unique
var spawn_area : Array
var wander_target : Vector2


func _ready() -> void:
	spawn_area.append(Vector2(global_position.x-30, global_position.y-30))
	spawn_area.append(Vector2(global_position.x+30, global_position.y+30))
	behavior_player.play("WANDER")
	player = get_tree().current_scene.find_child("Player")

func _physics_process(_delta) -> void:
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

			if global_position.distance_to(player.global_position) < 150:
				enemy_detection_ray.enabled = true
				enemy_detection_ray.target_position = to_local(player.global_position)
				if enemy_detection_ray.is_colliding():
					if enemy_detection_ray.get_collider().is_in_group("Player"):
						enemy_detection_ray.enabled = false
						enemy_detection_ray.target_position = Vector2(0, 0)
						behavior_player.play("FOLLOW")
			else:
				enemy_detection_ray.enabled = false
				enemy_detection_ray.target_position = Vector2(0, 0)
			
			if global_position.distance_to(wander_target) < 20 or is_on_wall_only():
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
				if global_position.distance_to(player.global_position) > 200: 
					enemy_detection_ray.enabled = false
					behavior_player.play("WANDER")
				elif enemy_hurt_box.has_overlapping_areas():
					for area in enemy_hurt_box.get_overlapping_areas():
						if area.is_in_group("Player"):
							behavior_player.play("ATTACK")
				else:
					behavior_player.play("FOLLOW")
			pass
		STATE.ATTACK:
			velocity = Vector2(0, 0)
			if enemy_hurt_box.has_overlapping_areas():
				for area in enemy_hurt_box.get_overlapping_areas():
						if area.is_in_group("Player"):
							behavior_player.play("ATTACK")
			else:
				behavior_player.play("FOLLOW")
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

func wander() -> void:
	var target_x = randi_range(spawn_area[0].x, spawn_area[1].x)
	var target_y = randi_range(spawn_area[0].y, spawn_area[1].y)
	wander_target = Vector2(target_x, target_y)
	
	
	nav.target_position = wander_target
	var dir = to_local(nav.get_next_path_position()).normalized()
	if dir.x > 0:
		sprite.scale.x = 1
	elif dir.x < 0:
		sprite.scale.x = -1

func follow() -> void:
	wander_target = player.global_position
	nav.target_position = wander_target

func stagger() -> void:
	PREV_ACTION = ACTION
	velocity = Vector2(0, 0)

func take_damage(damage) -> void:
	if ACTION != STATE.DYING:
		if health_bar == null:
			health_bar = HEALTH_INDICATOR.instantiate()
			health_bar.position = Vector2(0, -(sprite.texture.get_size().y))
			add_child(health_bar)
		HEALTH -= damage
		health_bar.change_health(-damage)

func is_dead() -> void:
	if HEALTH < 1:
		health_bar.queue_free()
		velocity = Vector2(0, 0)
		knockback_speed = Vector2(0, 0)
		behavior_player.stop()
		behavior_player.play("DYING")
