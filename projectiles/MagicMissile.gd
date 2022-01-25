extends "res://projectiles/BaseProjectile.gd"

var direction = Vector2.ZERO

func _ready():
	direction = (target - self.global_position).normalized()
	knockback_vector = direction
	$ColorRect.color.s = rand_range(0.5, 0.9)

func _process(delta):
	global_position += direction * delta * speed
	

func _on_FreeTimer_timeout():
	queue_free()

