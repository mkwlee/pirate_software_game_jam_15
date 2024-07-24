extends Node2D

@onready var health_change_bar: TextureProgressBar = $HealthBarContainer/HealthChangeBar
@onready var health_bar: TextureProgressBar = $HealthBarContainer/HealthBar

var health_change_delay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.value = get_parent().HEALTH
	health_change_bar.value = get_parent().HEALTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health_change_delay:
		if health_change_bar.value > health_bar.value: 
			health_change_bar.value = move_toward(health_change_bar.value, health_bar.value, round(health_change_delay*delta*20) / 10.0)
	
func change_health(amount):
	health_bar.value += amount
	health_change_delay = 0
	await get_tree().create_timer(0.5).timeout
	health_change_delay = health_change_bar.value - health_bar.value
