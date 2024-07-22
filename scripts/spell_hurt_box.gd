extends Area2D
const SPELL_EXPLOSION = preload("res://scenes/spells/spell_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().PERSIST and get_parent().velocity != Vector2(0,0):
		if get_parent().get_real_velocity().length() < 1:
			get_parent().queue_free()
	
func _on_body_entered(body):
	var spell = get_parent()
	if body.is_in_group("Enemy"):
		body.take_damage(randi_range(spell.DAMAGE.x, spell.DAMAGE.y))
		
		if spell.KNOCKBACK:
			body.push_position(global_position.direction_to(body.global_position), spell.SPEED)
		
		if spell.EXPLODE:
			var explosion = SPELL_EXPLOSION.instantiate()
			explosion.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", explosion)
		
		if not spell.PERSIST:
			spell.queue_free()
			
	elif body.name == "TileMap":
		get_parent().queue_free()
