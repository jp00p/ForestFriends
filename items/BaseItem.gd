extends Area2D
class_name Item

var speed = 600
var target = null setget set_target
export (bool) var magnetic = true
var is_collecting = false
	
func _process(delta):
	if target and is_collecting:
		global_position = lerp(global_position, target.global_position, 0.2)

func set_target(val):
	target = val
	if target and not is_collecting:
		is_collecting = true

func collect():
	$AnimationPlayer.play("collect")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
