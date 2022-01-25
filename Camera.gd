extends Camera2D

var move_speed = 0.5  # camera position lerp speed
var zoom_speed = 0.25  # camera zoom lerp speed
var min_zoom = 0.75  # camera won't zoom closer than this
var max_zoom = 1.25  # camera won't zoom farther than this
var margin = Vector2(150, 150)  # include some buffer area around targets
var min_pos = Vector2.ZERO
var max_pos = Vector2.ZERO
var r = Rect2(Vector2.ZERO, Vector2.ONE)
var targets = []  # Array of targets to be tracked.

onready var screen_size = get_viewport_rect().size

func _process(delta):
	if !targets:
		return
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)
	# Find the zoom that will contain all targets
	r = Rect2(position, Vector2.ONE)
	
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
	# Get the canvas transform
	var ctrans = get_canvas_transform()

	# The canvas transform applies to everything drawn,
	# so scrolling right offsets things to the left, hence the '-' to get the world position.
	# Same with zoom so we divide by the scale.
	min_pos = -ctrans.get_origin() / ctrans.get_scale()

	# The maximum edge is obtained by adding the rectangle size.
	# Because it's a size it's only affected by zoom, so divide by scale too.
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	max_pos = min_pos + view_size


	# Note: rotation is not taken into account here. An improvement would be
	# to use the inverse transform instead of this.

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.remove(t)
