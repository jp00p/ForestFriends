extends Node

signal xp_changed(val)
signal level_changed(val, next_level)

var A = 1
var B = 1
var C = 1

var xp = 0 setget set_xp
var level = 1 setget set_level
var next_level = 5

func _ready():
	randomize()

func set_xp(val):
	xp = val
	emit_signal("xp_changed", xp)
	if xp >= next_level:
		self.level += 1

func set_level(val):
	level = val
	self.next_level += round(next_level * log(next_level))
	print(next_level)
	emit_signal("level_changed", level, next_level)

func pause_game(state):
	get_tree().paused = state
