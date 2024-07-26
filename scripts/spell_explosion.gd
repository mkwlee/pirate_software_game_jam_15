extends Area2D

@onready var animation_player = $AnimationPlayer


var mod = false
var color
var enemy

func _ready() -> void:
	modulate = color
	if mod:
		animation_player.play("spell_explosion_mod")
	else:
		animation_player.play("spell_explosion")

func _process(_delta: float) -> void:
	if enemy != null:
		global_position = enemy.global_position
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var damage = Vector2()
		if mod:
			damage.x = randi_range(1, 2)
			damage.y = randi_range(1, 2)
		else:
			damage.x = randi_range(2, 3)
			damage.y = randi_range(2, 3)
		#print(["EXPLOSION", damage.x, damage.y, damage.x+damage.y])
		area.take_damage(damage.x+damage.y)
