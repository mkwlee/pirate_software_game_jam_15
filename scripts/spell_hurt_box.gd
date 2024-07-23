extends Area2D
const SPELL_EXPLOSION = preload("res://scenes/spells/spell_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().velocity != Vector2(0,0):
		if get_parent().get_real_velocity().length() < 1:
			get_parent().queue_free()
	
func _on_body_entered(body):
	var spell = get_parent()
	if body.is_in_group("Enemy"):
		var damage = Vector2()
		damage.x = randi_range(spell.DAMAGE.x/2, spell.DAMAGE.y/2)
		damage.y = randi_range(spell.DAMAGE.x/2, spell.DAMAGE.y/2)
		#print(["HURT", damage.x, damage.y, damage.x+damage.y])
		body.take_damage(damage.x+damage.y)
		
		#EARTH_SPELL knockback
		if spell.SHAPE == Global.SPELL_TYPE.EARTH_SPELL:
			body.push_position(global_position.direction_to(body.global_position).lerp(spell.velocity.normalized(), 0.5).normalized(), 
			(spell.DAMAGE.y*10)+(spell.SPEED*0.5))
		elif spell.MOD == Global.SPELL_TYPE.EARTH_SPELL:
			body.push_position(global_position.direction_to(body.global_position).lerp(spell.velocity.normalized(), 0.5).normalized(), 
			(spell.DAMAGE.x*10)+(spell.SPEED*0.2))
			
		
		#FIRE_SPELL explosion
		if spell.SHAPE == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(body, false, spell.modulate)
		elif spell.MOD == Global.SPELL_TYPE.FIRE_SPELL:
			create_explosion(body, true, spell.modulate)
		
		#WATER_SPELL persist
		if spell.SHAPE == Global.SPELL_TYPE.WATER_SPELL:
			pass
		elif spell.MOD == Global.SPELL_TYPE.WATER_SPELL:
			pass
		else:
			spell.queue_free()
			
	elif body.name == "TileMap":
		get_parent().queue_free()

func create_explosion(body, mod, color):
	var explosion = SPELL_EXPLOSION.instantiate()
	explosion.global_position = body.global_position
	explosion.mod = mod
	explosion.color = color
	explosion.enemy = body
	get_tree().current_scene.call_deferred("add_child", explosion)
	
