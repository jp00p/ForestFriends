extends Node2D

export (String) var weapon_name = "BaseWeapon"
export (float) var cooldown_speed = 2.5
export (int) var projectile_speed = 200
export (int) var projectile_damage = 1
export (int) var num_projectiles = 1
export (PackedScene) var projectile = load("res://projectiles/BaseProjectile.tscn")
signal create_projectile(p)
onready var muzzle = $Muzzle

func _ready():
	$Cooldown.wait_time = cooldown_speed
	$Cooldown.start()
	self.connect("create_projectile", owner, "create_projectile")
	
func fire():
	var p = projectile.instance()
	p.speed = projectile_speed
	p.damage = projectile_damage
	p.global_position = owner.global_position
	emit_signal("create_projectile", p)

func _on_Cooldown_timeout():
	fire()

func find_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var target = null
	if enemies:
		closest_enemy = enemies[0]
		# find enemies in range
		for e in enemies:
			if self.global_position.distance_to(e.global_position) < self.global_position.distance_to(closest_enemy.global_position):
				closest_enemy = e
	return closest_enemy
		
func _on_Range_body_entered(body):
	pass
	#body.modulate = Color.lime
