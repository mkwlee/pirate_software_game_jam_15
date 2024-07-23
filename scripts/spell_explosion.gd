extends Area2D

var mod = false
var color
var enemy

func _ready():
	modulate = color
	if mod:
		$AnimationPlayer.play("spell_explosion_mod")
	else:
		$AnimationPlayer.play("spell_explosion")

func _process(delta: float) -> void:
	global_position = enemy.global_position
	

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Enemy"):
		var damage = Vector2()
		if mod:
			damage.x = randi_range(2/2, 4/2)
			damage.y = randi_range(2/2, 4/2)
		else:
			damage.x = randi_range(4/2, 6/2)
			damage.y = randi_range(4/2, 6/2)
		#print(["EXPLOSION", damage.x, damage.y, damage.x+damage.y])
		body.take_damage(damage.x+damage.y)
