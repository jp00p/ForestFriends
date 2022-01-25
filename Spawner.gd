extends Node2D

signal spawn_enemy(enemy, num_enemies, pattern)

export (int) var total_enemies = 30 # how many monsters should this spawn in total
export (int) var num_per_spawn = 5 # how many monsters per spawn?
export (int) var spawn_cooldown = 1 # how many secs between spawns
export (int) var pattern = 0 # random distribution or clumping?
export (PackedScene) var enemy = null # which enemy to spawn

var enemies_spawned = 0

func _ready():
	$Timer.wait_time = spawn_cooldown
	$Timer.start()

func _on_Timer_timeout():
	enemies_spawned += num_per_spawn
	emit_signal("spawn_enemy", enemy, num_per_spawn, pattern)
	if enemies_spawned >= total_enemies:
		queue_free()
