extends Area2D

@export var active : bool = false
@export var DAMAGE : int
@export var KNOCKBACK : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active:
		for area in get_overlapping_areas():
			if area.is_in_group("Player"):
				area.take_damage(DAMAGE)
				active = false

func hurtbox_activate() -> void:
	active = true
	await get_tree().create_timer(0.1).timeout
	active = false
