extends Node

const MENU = preload("res://scenes/interfaces/menu.tscn")
const SLIME_ENEMY = preload("res://scenes/enemies/slime_enemy.tscn")

#Determines (Spell, Mod) : (SPELL_TYPE, SPELL_TYPE)
# Mod = -1 means no mod
var spell_a : Vector2i = Vector2i(-1, -1)
var spell_b : Vector2i = Vector2i(-1, -1)


var display_damage = false
var unlocked_spells = [1, 1, 1, 1]

var esc_menu : CanvasLayer = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Input.is_action_just_pressed("esc"):
		if esc_menu == null:
			esc_menu = MENU.instantiate()
			get_tree().current_scene.add_child(esc_menu)
			get_tree().paused = true
		else:
			esc_menu.queue_free()
			esc_menu = null
			get_tree().paused = false

func spawn_new_slimes(size_type, pos):
	match size_type:
		0:
			pass
		1:
			for x in range(0, 2):
				var e = SLIME_ENEMY.instantiate()
				e.size_type = 0
				e.global_position = pos
				if x:
					e.global_position += Vector2(3, 3)
				else:
					e.global_position -= Vector2(3, 3)
				get_tree().current_scene.add_child(e)
		2:
			for x in range(0, 2):
				var e = SLIME_ENEMY.instantiate()
				e.size_type = 1
				e.global_position = pos
				if x:
					e.global_position += Vector2(3, 3)
				else:
					e.global_position -= Vector2(3, 3)
				get_tree().current_scene.add_child(e)
				pass
