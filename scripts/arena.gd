extends Node2D

const SHADE_ENEMY = preload("res://scenes/enemies/shade_enemy.tscn")
const BAT_ENEMY = preload("res://scenes/enemies/bat_enemy.tscn")
const CYPRUS_ENEMY = preload("res://scenes/enemies/cyprus_enemy.tscn")
const SLIME_ENEMY = preload("res://scenes/enemies/slime_enemy.tscn")

const SPELL_PICKUP = preload("res://scenes/environment/spell_pickup.tscn")

@onready var tile_map: TileMap = $TileMap
@onready var round_label: Label = $ArenaInfo/RoundLabel
@onready var enemies_label: Label = $ArenaInfo/EnemiesLabel
@onready var round_start_timer: Timer = $RoundStartTimer
@onready var spell_markers : Array = [$LeftSpell, $RightSpell]


var tiles : Array

var current_round : int = 1

var round_break = true
var spell_tracker : Array = [0, 0, 0, 0]
var spell_options : Array
var spell_options_type : Array

var spawn_amount : Vector2i = Vector2i(2, 5)
var spawn_increase : Vector2i = Vector2i(0, 2)
var wave_amount : int = 0
var enemies : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tiles = tile_map.get_used_cells(0)
	for t in tiles:
		if tile_map.get_cell_tile_data(0, t).get_custom_data("Ground") == false:
			tiles.erase(t)
	for x in range(0, GameManager.unlocked_spells.size()):
		GameManager.unlocked_spells[x] = 0
	GameManager.spell_a.x = -1
	GameManager.spell_a.y = -1
	GameManager.spell_b.x = -1
	GameManager.spell_b.y = -1
	get_tree().current_scene.find_child("GUI").set_spell_slots()
	spawn_spells()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if round_break == true:
		round_label.text = "Round "+str(current_round)
		enemies_label.text = ""
		
		var x = 0
		for s in spell_options:
			# If Spell is null (chosen)
			if s == null:
				#Set spell tracker of type to 3
				spell_tracker[spell_options_type[x]] = 3
				GameManager.unlocked_spells[spell_options_type[x]] = 1
				#Queue free other spell
				if x:
					spell_options[0].queue_free()
				else:
					spell_options[1].queue_free()
				
				spell_options = []
				spell_options_type = []
				round_start_timer.start()
				round_break = false
				break
			x += 1
	else:
		for e in enemies:
			if e == null:
				enemies.erase(e)
			
		if round_start_timer.is_stopped():
			round_label.text = "Round "+str(current_round)
			enemies_label.text = "Enemies\n"+str(enemies.size())
			
			if enemies.is_empty():
				current_round += 1
				spawn_amount += spawn_increase
				spawn_increase += Vector2i(randi_range(0, 1), randi_range(1, 2))
				round_break = true
				for x in range(0, spell_tracker.size()):
					if spell_tracker[x] >= 1:
						spell_tracker[x] -= 1
						
					if spell_tracker[x] == 0:
						GameManager.unlocked_spells[x] = 0
						if GameManager.spell_a.x == x or GameManager.spell_a.y == x:
							GameManager.spell_a.x = -1
							GameManager.spell_a.y = -1
							get_tree().current_scene.find_child("GUI").set_spell_slots()
						elif GameManager.spell_b.x == x or GameManager.spell_b.y == x:
							GameManager.spell_b.x = -1
							GameManager.spell_b.y = -1
							get_tree().current_scene.find_child("GUI").set_spell_slots()
				spawn_spells()
				
		else:
			round_label.text = "Round "+str(current_round)
			enemies_label.text = "Round starts in: "+str(ceil(round_start_timer.time_left))

func start_round() -> void:
	for s in randi_range(spawn_amount.x, spawn_amount.y):
		var enemy = spawn_enemy()
		var location = tile_map.map_to_local(tiles[randi_range(0, tiles.size()-1)])
		enemy.global_position = to_global(location)
		enemies.append(enemy)
		get_tree().current_scene.add_child(enemy)

func spawn_enemy() -> CharacterBody2D:
	match randi_range(0, 9):
		0, 1, 2, 3, 4:
			return SHADE_ENEMY.instantiate()
		5, 6:
			return BAT_ENEMY.instantiate()
		7, 8:
			return SLIME_ENEMY.instantiate()
		9:
			return CYPRUS_ENEMY.instantiate()
		_:
			return SHADE_ENEMY.instantiate()

func spawn_spells():
	# Get list of spell not already had
	var spell_avail : Array = []
	for i in range(0, spell_tracker.size()):
		if spell_tracker[i] == 0:
			spell_avail.append(i)
			
	for x in range(0, 2):
		var s = SPELL_PICKUP.instantiate()
		
		# Set spell as random avail spell and remove from avail list
		s.SPELL = spell_avail[randi_range(0, spell_avail.size()-1)]
		spell_avail.erase(s.SPELL)
		
		# Append chosen spell node and type
		spell_options.append(s)
		spell_options_type.append(s.SPELL)
		
		s.global_position = spell_markers[x].global_position
		get_tree().current_scene.add_child(s)

func _on_round_start_timer_timeout() -> void:
	start_round()
