extends "res://projectiles/BaseProjectile.gd"


func _ready():
	knockback_vector = player.direction
	$AnimatedSprite.play("default")
	if player.direction.x == 1:
		$AnimatedSprite.flip_h = true

func _on_AnimatedSprite_animation_finished():
	queue_free()
