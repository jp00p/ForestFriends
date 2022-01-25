extends "res://projectiles/BaseProjectile.gd"

var rotation_speed = 10
var duration = 10
var pivot = null

func _ready():
	$Timer.wait_time = duration
	$Timer.start()
	if randi() % 2 == 0:
		rotation_speed = -10

func _process(delta):
	$Sprite.rotation += rotation_speed * delta
	knockback_vector = -self.global_position.direction_to(pivot.global_position).normalized()

func _on_BaseProjectile_body_entered(body):
	if body is Enemy:
		target = body
		knockback_vector = target.player_direction
		knockback_vector = -knockback_vector
		._on_BaseProjectile_area_entered(body)

func _on_Timer_timeout():
	queue_free()
