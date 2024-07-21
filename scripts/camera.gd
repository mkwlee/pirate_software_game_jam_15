extends Camera2D

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var viewport = get_viewport_rect().size
	print(mouse_pos - player.global_position)
	offset = (mouse_pos - player.global_position) / (viewport / 20)
