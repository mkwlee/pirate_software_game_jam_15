extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().PERSIST and get_parent().velocity != Vector2(0,0):
		if get_parent().get_real_velocity().length() < 1:
			get_parent().queue_free()
	
func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("Enemy"):
		body.take_damage(get_parent().velocity*int(get_parent().KNOCKBACK), get_parent().PERSIST)
		if not get_parent().PERSIST:
			get_parent().queue_free()
	elif body.name == "TileMap":
		get_parent().queue_free()
