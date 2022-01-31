extends "res://weapons/BaseWeapon.gd"

var target = null
var spread = 33

func _on_Cooldown_timeout():
	target = find_closest_enemy()
	if target:
		fire()

func fire():
	for i in range(num_projectiles):
		var p = projectile.instance()
		p.speed = projectile_speed
		p.damage = projectile_damage
		p.player = self.player
		p.global_position = global_position
		p.target = target.global_position
		match i:
			1:
				p.target += Vector2(-spread, -spread)
			2:
				p.target += Vector2(spread, spread)
			3:
				p.target += Vector2(spread, -spread)
			4:
				p.target += Vector2(-spread, spread)
		emit_signal("create_projectile", p, false)
