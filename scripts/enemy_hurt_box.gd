extends Area2D

@export var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		for area in get_overlapping_areas():
			if area.is_in_group("Player"):
				area.take_damage(10)
				active = false


#func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Player"):
		#print("HIT")

func hurtbox_activate():
	active = true
	await get_tree().create_timer(0.1).timeout
	active = false
