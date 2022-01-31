extends "res://projectiles/BaseProjectile.gd"

var direction = Vector2.ZERO

func _ready():
	direction = (target - self.global_position).normalized()
	knockback_vector = direction

func _process(delta):
	global_position += direction * delta * speed
	$Sprite.rotation += 10 * delta

func _on_FreeTimer_timeout():
	queue_free()

