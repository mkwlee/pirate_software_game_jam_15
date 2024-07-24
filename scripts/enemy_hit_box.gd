extends Area2D

const DAMAGE_INDICATOR = preload("res://scenes/enemies/damage_indicator.tscn")
var enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy = get_parent()

func take_damage(damage : int):
	var dmg = DAMAGE_INDICATOR.instantiate()
	dmg.position = Vector2(randi_range(-8, 8), randi_range(-8, 8))
	dmg.get_child(0).text = str(damage)
	add_child(dmg)
	if enemy.damage_player.is_playing():
		enemy.damage_player.stop()
	enemy.damage_player.play("take_damage")
	
	if enemy.can_stagger:
		#enemy.ACTION = enemy.STATE.STAGGER
		enemy.behavior_player.play("STAGGER")
func push_position(direction, speed):
	enemy.knockback_speed = direction*speed
