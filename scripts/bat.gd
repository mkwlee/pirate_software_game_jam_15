extends CharacterBody2D

const HEALTH_INDICATOR = preload("res://scenes/enemies/health_indicator.tscn")

@onready var damage_player: AnimationPlayer = $DamagePlayer
@onready var player: CharacterBody2D = %Player
@onready var sprite = $Sprite2D
@onready var nav= $NavigationAgent2D
@onready var behavior_player = $BehaviorPlayer
@onready var animation_player = $AnimationPlayer
@onready var enemy_detection_ray = $EnemyDetectionRay
@onready var enemy_hurt_box = $Sprite2D/EnemyHurtBox



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

func _ready() -> void:
	spawn_area.append(Vector2(global_position.x-50, global_position.y-50))
	spawn_area.append(Vector2(global_position.x+50, global_position.y+50))
	behavior_player.play("WANDER")
	
func _physics_process(_delta) -> void:
	match ACTION:
		STATE.IDLE:
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
						enemy_detection_ray.enabled = false
						enemy_detection_ray.target_position = Vector2(0, 0)
						behavior_player.play("FOLLOW")
			
			
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
				elif global_position.distance_to(player.global_position) < 80: 
					behavior_player.play("ATTACK")
				else:
					behavior_player.play("FOLLOW")
		STATE.ATTACK:
			var dir = wander_target
			velocity = (dir * SPEED*2)
			
			if is_on_wall():
				behavior_player.play("WANDER")
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
						behavior_player.play("ATTACK")
	

	velocity += knockback_speed
	move_and_slide()
	if knockback_speed:
		knockback_speed.x = lerp(knockback_speed.x, 0.0, 0.1)
		knockback_speed.y = lerp(knockback_speed.y, 0.0, 0.1)

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
		behavior_player.play("DYING")

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

func attack() -> void:
	wander_target = player.global_position
	wander_target = global_position.direction_to(wander_target).normalized()
	if wander_target.x > 0:
		sprite.scale.x = 1
	elif wander_target.x < 0:
		sprite.scale.x = -1
	
func stagger() -> void:
	PREV_ACTION = ACTION
	velocity = Vector2(0, 0)

func _on_enemy_hurt_box_area_entered(area) -> void:
	if ACTION == STATE.ATTACK:
		if area.is_in_group("Player"):
			enemy_hurt_box.hurtbox_activate()
