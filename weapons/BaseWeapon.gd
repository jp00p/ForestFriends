extends Node2D

class_name Weapon

export (String) var weapon_name = "BaseWeapon"
export (float) var cooldown_speed = 2.5
export (int) var projectile_speed = 200
export (int) var projectile_damage = 1
export (int) var num_projectiles = 1
export (String) var description = ""
export (PackedScene) var projectile = load("res://projectiles/BaseProjectile.tscn")
signal create_projectile(p,local)
onready var muzzle = $Muzzle
var player = null
var level = 1
var max_level = 8

func _ready():
	player = get_parent().get_parent()
	$Cooldown.wait_time = cooldown_speed
	$Cooldown.start()

	# TODO remember why i did this
	var cproj = player.get_signal_list()
	var signalname = "create_projectile"
	if cproj.find(signalname,0) == -1:
		self.connect("create_projectile", player, "create_projectile")
	
func fire():
	var p = projectile.instance()
	p.speed = projectile_speed
	p.damage = projectile_damage
	if player:
		p.player = player
		p.global_position = player.global_position
	emit_signal("create_projectile", p, false)

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

func get_upgrade_text():
	pass
	
func level_up():
	pass
