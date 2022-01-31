extends Weapon

func fire():
	pass
	
func _on_Cooldown_timeout():
	$Pivot.rotation = deg2rad(rand_range(1,360))
	var p = projectile.instance()
	p.speed = projectile_speed
	p.damage = projectile_damage
	p.player = player
	p.global_position = player.global_position
	p.point_to = $Pivot/SpawnPoint.global_position
	emit_signal("create_projectile", p, false)
