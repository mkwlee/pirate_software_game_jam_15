extends Area2D
@onready var sprite: Sprite2D = $Sprite2D

@export var SPELL : Global.SPELL_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = Global.spell_icons[SPELL]
	sprite.modulate = Global.spell_colors[SPELL]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		GameManager.unlocked_spells[SPELL] = 1
		if GameManager.spell_a.x == -1:
			GameManager.spell_a.x = SPELL
			GameManager.spell_a.y = SPELL
			get_tree().current_scene.find_child("GUI").set_spell_slots()
			queue_free()
