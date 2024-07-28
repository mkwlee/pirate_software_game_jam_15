extends Area2D

const DAMAGE_INDICATOR = preload("res://scenes/enemies/damage_indicator.tscn")

@onready var DAMAGE_INDICATORS : Array = [$DamageIndicator, $DamageIndicator2, $DamageIndicator3, $DamageIndicator4, $DamageIndicator5, $DamageIndicator6]
var curr_indicator : int = 0

@export var CAN_BE_DAMAGED : bool = true

var enemy

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	enemy = get_parent()

func take_damage(damage : int) -> void:
	if CAN_BE_DAMAGED:
		#call_deferred("create_damage_indicator", damage)
		if GameManager.display_damage:
			create_damage_indicator(damage)
		
		enemy.take_damage(damage)
		
		if enemy.damage_player.is_playing():
			enemy.damage_player.stop()
		enemy.damage_player.play("take_damage")
		
		if enemy.can_stagger:
			enemy.behavior_player.play("STAGGER")
		
func push_position(direction, speed) -> void:
	if CAN_BE_DAMAGED:
		enemy.knockback_speed = direction*speed
		
func create_damage_indicator(damage : int) -> void:
	DAMAGE_INDICATORS[curr_indicator].run_indicator(damage)
	curr_indicator = (curr_indicator+1) % 6
	#var dmg = DAMAGE_INDICATOR.instantiate()
	#dmg.position = Vector2(randi_range(-8, 8), randi_range(-8, 8))
	#dmg.get_child(0).text = str(damage)
	#add_child(dmg)
	
func player_dead():
	get_parent().behavior_player.stop()
	get_parent().ACTION = get_parent().STATE.IDLE
