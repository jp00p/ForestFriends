extends Weapon

func _ready():
	print(player)

func fire():
	print(player.direction)
	var p = projectile.instance()
	p.speed = projectile_speed
	p.damage = projectile_damage
	if player:
		p.player = player
		p.position.x = (33 * player.direction.x)
	emit_signal("create_projectile", p, true)
