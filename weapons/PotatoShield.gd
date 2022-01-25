extends "res://weapons/BaseWeapon.gd"

export (int) var rotation_speed = 3

func fire():
	# in this case we want the potato to stay attached to the weapon
	pass

func _on_Cooldown_timeout():
	if $Pivot/PotatoSpawn.get_child_count() < 1:
		var p = projectile.instance()
		p.pivot = $Pivot
		$Pivot/PotatoSpawn.add_child(p)
	
func _process(delta):
	$Pivot.rotation += rotation_speed * delta
