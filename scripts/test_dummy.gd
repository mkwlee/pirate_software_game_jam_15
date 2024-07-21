extends CharacterBody2D

func _physics_process(delta):
	pass

func take_damage():
	print("DAMAGE")
	$AnimationPlayer.play("take_damage")
