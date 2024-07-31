extends CharacterBody2D

@onready var enemy_hurt_box: Area2D = $EnemyHurtBox

@export var SPEED : int

var target : Vector2
var direction : Vector2
func _ready() -> void:
	direction = global_position.direction_to(target).normalized()*SPEED

func _physics_process(delta: float) -> void:
	velocity = direction
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "TileMap":
			queue_free()


func _on_enemy_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		enemy_hurt_box.hurtbox_activate()
		await get_tree().create_timer(0.1).timeout
		queue_free()
