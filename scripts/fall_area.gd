extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("Player") and area.get_parent().player_movement_animations.current_animation != "player_dash":
			area.get_parent().player_movement_animations.play("player_fall")
		elif area.is_in_group("Enemy"):
			area.get_parent().HEALTH = 0
			area.get_parent().is_dead()
