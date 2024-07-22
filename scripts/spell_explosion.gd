extends Area2D


func _ready():
	$AnimationPlayer.play("spell_explosion")


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Enemy"):
		body.take_damage(randi_range(2, 6))
