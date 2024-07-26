extends Area2D
const SPELL_EXPLOSION = preload("res://scenes/spells/spell_explosion.tscn")
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if get_parent().velocity != Vector2(0,0):
		if get_parent().get_real_velocity().length() < 1:
			get_parent().queue_free()


func _on_area_entered(area) -> void:
	var spell = get_parent()
	if area.is_in_group("Enemy"):
		var damage = Vector2()
		damage.x = randi_range(spell.DAMAGE.x/2, spell.DAMAGE.y/2)
		damage.y = randi_range(spell.DAMAGE.x/2, spell.DAMAGE.y/2)
		#print(["HURT", damage.x, damage.y, damage.x+damage.y])
		area.take_damage(damage.x+damage.y)
		
		#EARTH_SPELL knockback
		if spell.SHAPE == Global.SPELL_TYPE.EARTH_SPELL:
			area.push_position(global_position.direction_to(area.global_position).lerp(spell.velocity.normalized(), 0.5).normalized(), 
			150)
		elif spell.MOD == Global.SPELL_TYPE.EARTH_SPELL:
			area.push_position(global_position.direction_to(area.global_position).lerp(spell.velocity.normalized(), 0.5).normalized(), 
			100)
			
		
		#FIRE_SPELL explosion
		if spell.SHAPE == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(area, false, spell.modulate)
		elif spell.MOD == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(area, true, spell.modulate)
		
		#WATER_SPELL persist
		if spell.SHAPE == Global.SPELL_TYPE.WATER_SPELL:
			pass
		elif spell.MOD == Global.SPELL_TYPE.WATER_SPELL:
			pass
		else:
			spell.queue_free()

func create_explosion(area, mod, color) -> void:
	var explosion = SPELL_EXPLOSION.instantiate()
	explosion.global_position = area.global_position
	explosion.mod = mod
	explosion.color = color
	explosion.enemy = area
	get_tree().current_scene.call_deferred("add_child", explosion)
	


func _on_body_entered(body: Node2D) -> void:
	var spell = get_parent()
	if body.name == "TileMap":
		#FIRE_SPELL explosion
		if spell.SHAPE == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(spell, false, spell.modulate)
		elif spell.MOD == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(spell, true, spell.modulate)
		
		get_parent().queue_free()
