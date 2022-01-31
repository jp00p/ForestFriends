extends CanvasLayer

onready var progress = $XP/Margin/VBoxContainer/ProgressBar

func _ready():
	Globals.connect("xp_changed", self, "xp_changed")
	Globals.connect("level_changed", self, "level_changed")
	progress.max_value = Globals.next_level

func xp_changed(val):
	progress.value = val
	
func _process(delta):
	$Count.text = "Enemies: %s" % get_tree().get_nodes_in_group("enemies").size()
	$FPS.text = "FPS: %s" % str(Engine.get_frames_per_second())

func level_changed(val, next_level):
	$XP/Margin/VBoxContainer/Label.text = "LEVEL: %s" % val
	progress.min_value = progress.max_value
	progress.max_value = next_level
	# show level up screen
	# Globals.pause_game(true)
