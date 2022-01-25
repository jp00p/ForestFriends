extends "res://weapons/BaseWeapon.gd"

var target = null

func _on_Cooldown_timeout():
	target = find_closest_enemy()
	if target:
		fire()

func fire():
	for i in range(num_projectiles):
		var p = projectile.instance()
		p.speed = projectile_speed
		p.damage = projectile_damage
		p.global_position = global_position
		p.target = target.global_position
		emit_signal("create_projectile", p)
