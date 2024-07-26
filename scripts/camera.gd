extends Camera2D

@onready var player = %Player

var mouse_in_game = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if mouse_in_game:
		var mouse_pos = get_global_mouse_position()
		var viewport = get_viewport_rect().size
		offset = (mouse_pos - player.global_position) / (viewport / 200)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_in_game = false
			pass
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_in_game = true
			pass
