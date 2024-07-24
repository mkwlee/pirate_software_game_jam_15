extends CanvasLayer

@onready var spell_slots : Array = [
	[$MarginContainer/HBoxContainer/TextureRect/SpellAIcon, $MarginContainer/HBoxContainer/TextureRect/SpellAProgress],
	[$MarginContainer/HBoxContainer/TextureRect2/SpellBIcon, $MarginContainer/HBoxContainer/TextureRect2/SpellBProgress]
]
@onready var health_bar: TextureProgressBar = $MarginContainer/HealthBar



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_spell_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for slot in range(0, 2):
		if spell_slots[slot][1].value > 0:
			spell_slots[slot][1].value -= delta
	
func set_spell_cooldown(slot : int, length : float):
	spell_slots[slot][1].max_value = length
	spell_slots[slot][1].value = length

func set_spell_slots():
	var spell_array = [GameManager.spell_a, GameManager.spell_b]
	for slot in range(0, 2):
		spell_slots[slot][0].texture = Global.spell_icons[spell_array[slot].x]
		spell_slots[slot][0].modulate = Global.spell_colors[spell_array[slot].y]


func _on_player_health_change_signal(new_health: Variant) -> void:
	health_bar.value = new_health
