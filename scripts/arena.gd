extends Node2D

const SHADE_ENEMY = preload("res://scenes/enemies/shade_enemy.tscn")
const BAT_ENEMY = preload("res://scenes/enemies/bat_enemy.tscn")

@onready var tile_map: TileMap = $TileMap
@onready var round_label: Label = $ArenaInfo/RoundLabel
@onready var enemies_label: Label = $ArenaInfo/EnemiesLabel
@onready var round_start_timer: Timer = $RoundStartTimer

var tiles : Array

var current_round : int = 1

var spawn_amount : Vector2i = Vector2i(2, 5)
var spawn_increase : Vector2i = Vector2i(1, 3)
var wave_amount : int = 0
var enemies : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tiles = tile_map.get_used_cells(0)
	for t in tiles:
		if tile_map.get_cell_tile_data(0, t).get_custom_data("Ground") == false:
			tiles.erase(t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for e in enemies:
		if e == null:
			enemies.erase(e)
	
	if round_start_timer.is_stopped():
		round_label.text = "Round "+str(current_round)
		enemies_label.text = "Enemies\n"+str(enemies.size())
		
		if enemies.is_empty():
			current_round += 1
			spawn_amount += spawn_increase
			spawn_increase += Vector2i(randi_range(0, 2), randi_range(1, 3))
			round_start_timer.start()
	else:
		round_label.text = "Round starts in: "+str(ceil(round_start_timer.time_left))
		enemies_label.text = ""

func start_round() -> void:
	for s in randi_range(spawn_amount.x, spawn_amount.y):
		var enemy = spawn_enemy()
		var location = tile_map.map_to_local(tiles[randi_range(0, tiles.size()-1)])
		enemy.global_position = to_global(location)
		enemies.append(enemy)
		get_tree().current_scene.add_child(enemy)

func spawn_enemy() -> CharacterBody2D:
	if randi_range(0, 9) < 8:
		return SHADE_ENEMY.instantiate()
	else:
		return BAT_ENEMY.instantiate()

func _on_round_start_timer_timeout() -> void:
	start_round()
