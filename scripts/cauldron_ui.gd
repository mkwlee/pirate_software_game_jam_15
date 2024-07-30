extends CanvasLayer

@onready var spell_list_container: HFlowContainer = $TextureRect/SpellListContainer
@onready var spell_container: HFlowContainer = $TextureRect/SpellContainer

@onready var spell_a_container: TextureRect = $TextureRect/SpellContainer/SpellAContainer
@onready var spell_b_container: TextureRect = $TextureRect/SpellContainer/SpellBContainer


const CAULDRON_SPELL = preload("res://scenes/interfaces/cauldron/cauldron_spell.tscn")
# Called when the node enters the scene tree for the first time.

var spell_list : Array

func _ready() -> void:
	var spell_check = GameManager.unlocked_spells
	for i in spell_check.size():
		if spell_check[i]:
			var s = CAULDRON_SPELL.instantiate()
			s.panel_type = 0
			s.spell_id = i
			s.spell_mod = i
			s.texture = Global.spell_icons[i]
			s.modulate = Global.spell_colors[i]
			s.set_tooltip()
			spell_list.append(s)
			spell_list_container.add_child(s)
		else:
			spell_list.append(null)
	
	#spell_a_container.texture = Global.spell_icons[GameManager.spell_a.x]
	#spell_a_container.modulate = Global.spell_colors[GameManager.spell_a.y]
	#spell_b_container.texture = Global.spell_icons[GameManager.spell_b.x]
	#spell_b_container.modulate = Global.spell_colors[GameManager.spell_b.y]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if spell_a_container.spell_id > -1 and spell_b_container.spell_id > -1:
		GameManager.spell_a.x = spell_a_container.spell_id
		if spell_a_container.spell_mod == -1:
			GameManager.spell_a.y = spell_a_container.spell_id
		else:
			GameManager.spell_a.y = spell_a_container.spell_mod
			
		GameManager.spell_b.x = spell_b_container.spell_id
		if spell_b_container.spell_mod == -1:
			GameManager.spell_b.y = spell_b_container.spell_id
		else:
			GameManager.spell_b.y = spell_b_container.spell_mod
		get_tree().paused = false
		queue_free()
		

func _on_reset_button_pressed() -> void:
	for spell in spell_list:
		if spell != null:
			spell.reset()
	spell_a_container.reset()
	spell_b_container.reset()
