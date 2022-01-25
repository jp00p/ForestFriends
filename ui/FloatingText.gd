extends Node2D

var text = ""

func _ready():
	$Text/Label.text = text
	$AnimationPlayer.play("float")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
