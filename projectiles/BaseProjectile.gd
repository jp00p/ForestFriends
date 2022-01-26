extends Area2D

# these should be set by weapon
var speed = 100 
var damage = 1
var knockback_vector = Vector2.ZERO
var target = null
var player = null
export (bool) var passthrough = false # does it go thru enemies?
 
func _on_BaseProjectile_body_entered(body):
	if body is Enemy and body.has_method("take_damage"):
		body.take_damage(damage, knockback_vector)
		if not passthrough:
			queue_free()

func _on_BaseProjectile_area_entered(area):
	if area is Enemy and area.has_method("take_damage"):
		area.take_damage(damage, knockback_vector)
		if not passthrough:
			queue_free()
