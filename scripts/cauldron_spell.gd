extends TextureRect


const SPELL_SLOT_RECHARGE = preload("res://assets/sprites/UI/spells/spell_slot_recharge.png")
@onready var cauldron_ui = $"../../.."

# 0 = Spell list
# 1 = Spell A
# 2 = Spell B
@export var panel_type : int = 0

# 0 = Spell shape dropable
# 1 = Spell mod dropable
var slot_state = 0

var list_state = 1

var spell_id : int = -1
var spell_mod : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if panel_type:
		mouse_default_cursor_shape = Control.CURSOR_ARROW

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not panel_type and list_state:
		var pt = TextureRect.new()
		pt.texture = texture
		pt.modulate = modulate
		pt.expand_mode = 1
		pt.size = Vector2(100, 100)
		pt.position -= Vector2(5, 5)
		set_drag_preview(pt)
		return spell_id
	else:
		return null
		
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return panel_type == 1 or panel_type == 2
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	cauldron_ui.spell_list[data].texture = SPELL_SLOT_RECHARGE
	cauldron_ui.spell_list[data].modulate = Color.WHITE
	cauldron_ui.spell_list[data].list_state = false

	match slot_state:
		0:
			texture = Global.spell_icons[data]
			modulate = Global.spell_colors[data]
			if spell_id != -1:
				cauldron_ui.spell_list[spell_id].texture = Global.spell_icons[spell_id]
				cauldron_ui.spell_list[spell_id].modulate = Global.spell_colors[spell_id]
				cauldron_ui.spell_list[spell_id].list_state = true
			if spell_mod != -1:
				cauldron_ui.spell_list[spell_mod].texture = Global.spell_icons[spell_mod]
				cauldron_ui.spell_list[spell_mod].modulate = Global.spell_colors[spell_mod]
				cauldron_ui.spell_list[spell_mod].list_state = true
			spell_id = data
			spell_mod = -1
			slot_state = 1
		1:
			modulate = Global.spell_colors[data]
			spell_mod = data
			slot_state = 0
	set_tooltip()

func reset() -> void:
	if panel_type == 0:
		texture = Global.spell_icons[spell_id]
		modulate = Global.spell_colors[spell_id]
		list_state = true
	else:
		texture = SPELL_SLOT_RECHARGE
		modulate = Color.WHITE
		spell_id = -1
		spell_mod = -1
		slot_state = 0
		

func set_tooltip():
	var tip : String = ""
	if panel_type == 0:
		tip += 'Click and drag spells to use'
	else:
		tip += 'Drag a spell here to use or to use as a modifier'
		
	if spell_id != -1:
		tip += "\nSpell: "+Global.spell_descriptions[spell_id]
	else:
		tip += "\nSpell: None. Drag a spell onto here to set."
	
	if spell_mod != -1:
		tip += "\nMod: "+Global.mod_descriptions[spell_mod]
	else:
		tip += "\nMod: None. Drag a spell onto here to set."
	tooltip_text = tip
