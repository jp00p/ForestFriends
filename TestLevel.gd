extends Node2D

export (Array, PackedScene) var wave_progression
var current_wave = 0 setget set_wave

var spawn_buffer_range = 200

onready var spawner = preload("res://Spawner.tscn")
onready var tiles = $TileMap

func _ready():
	$Camera.add_target($Player)
	$Camera.add_target($Player2)

	# set camera limits based on size of world
	#var r = $TileMap.get_used_rect()
	#$Camera.limit_left = r.position.x * $TileMap.cell_size.x
	#$Camera.limit_right = r.end.x * $TileMap.cell_size.x
	#$Camera.limit_top = r.position.y * $TileMap.cell_size.y
	#$Camera.limit_bottom = r.end.y * $TileMap.cell_size.y
	
	# add first spawner
	if wave_progression:
		add_spawner(wave_progression[current_wave])

func _on_SpawnTimer_timeout():
	# every 30 seconds, add a new spawner
	self.current_wave += 1
	print("Current Wave: %s" % current_wave)
	var spawner = wave_progression[current_wave]
	if spawner:
		add_spawner(spawner)

func add_spawner(spawner):
	# create a new spawner and add to scene
	var s = spawner.instance()
	s.connect("spawn_enemy", self, "spawn_enemy")
	add_child(s)
	
func spawn_enemy(enemy, num_enemies, pattern):
	# spawn an enemy on the scene with given pattern
	for i in range(num_enemies):
		var spawn_location_x
		var spawn_location_y
		var e = enemy.instance()
		e.connect("drop_item", self, "spawn_item")
		
		# TODO: add more patterns, maybe move this to spawner scene
		var spawn_loc = randi()%4
		match spawn_loc:
			0: # top
				spawn_location_x = rand_range($Camera.min_pos.x - spawn_buffer_range, $Camera.max_pos.x + spawn_buffer_range)
				spawn_location_y = rand_range($Camera.min_pos.y - spawn_buffer_range, $Camera.min_pos.y - spawn_buffer_range)
			1: # right
				spawn_location_x = rand_range($Camera.max_pos.x + spawn_buffer_range, $Camera.max_pos.x + spawn_buffer_range)
				spawn_location_y = rand_range($Camera.min_pos.y - spawn_buffer_range, $Camera.max_pos.y + spawn_buffer_range)
			2: # bottom
				spawn_location_x = rand_range($Camera.max_pos.x - spawn_buffer_range, $Camera.max_pos.x + spawn_buffer_range)
				spawn_location_y = rand_range($Camera.max_pos.y + spawn_buffer_range, $Camera.max_pos.y + spawn_buffer_range)
			3: # left
				spawn_location_x = rand_range($Camera.min_pos.x - spawn_buffer_range, $Camera.min_pos.x - spawn_buffer_range)
				spawn_location_y = rand_range($Camera.min_pos.y - spawn_buffer_range, $Camera.max_pos.y + spawn_buffer_range)
				
		e.global_position = Vector2(spawn_location_x, spawn_location_y)
		add_child(e)

func spawn_item(item, where):
	# spawn an item in a location in this scene
	var i = item.instance()
	i.global_position = where
	call_deferred("add_child", i)

func set_wave(val):
	current_wave = wrapi(val, 0, wave_progression.size()-1)


func draw_background_tiles():
	var pos = $Camera.global_position
	var camera_position = tiles.world_to_map(pos)
	var boundaries = generate_tile_boundaries(camera_position)
	
	for i in boundaries:
		var tile = tiles.get_cell(i.x, i.y)
		var has_tile = tile > -1
		if !has_tile:
			draw_new_cell(tiles, i.x, i.y, 0)
	
func generate_tile_boundaries(pos):
	var boundaries = [pos]
	for x in 36:
		for y in 30:
			boundaries.append({
				"x" : pos.x + x,
				"y" : pos.y + y
			})
			boundaries.append({
				"x" : pos.x - x,
				"y" : pos.y - y
			})
			boundaries.append({
				"x" : pos.x - x,
				"y" : pos.y + y
			})
			boundaries.append({
				"x" : pos.x + x,
				"y" : pos.y - y
			})
	return boundaries
	
func draw_new_cell(tilemap, x, y, id):
	tilemap.set_cell(x, y, id, false, false, false, get_subtile_with_priority(id, tilemap))

func get_subtile_with_priority(id, tilemap):
	var tileset = tiles.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
	var size_x = rect.size.x / tileset.autotile_get_size(id).x
	var size_y = rect.size.y / tileset.autotile_get_size(id).y
	var tile_array = []
	for x in range(size_x):
		for y in range(size_y):
			var priority = tileset.autotile_get_subtile_priority(id, Vector2(x, y))
			for p in priority:
				tile_array.append(Vector2(x,y))
	return tile_array[randi() % tile_array.size()]


func _on_DrawTimer_timeout():
	draw_background_tiles()
