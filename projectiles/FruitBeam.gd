extends "res://projectiles/BaseProjectile.gd"

func _ready():
	self.rotation_degrees = rand_range(1,360)
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
