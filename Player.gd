extends KinematicBody2D

class_name Player

export (int) var player_id = 1
export (PackedScene) var starting_weapon

var base_speed = 160
var speed = base_speed
var friction = 0.9
var acceleration = 0.25
var velocity = Vector2()
var flash = 0 setget set_flash
var camera = null
var max_hp = 25 setget set_max_hp
var hp = max_hp setget set_hp
var iframes_active = false
var regen_amt = 1
var dead = false
var direction = Vector2(-1, 0)

onready var health_bar = $HealthBar/ProgressBar

func _ready():
	self.max_hp = max_hp
	self.hp = max_hp
	if starting_weapon:
		var w = starting_weapon.instance()
		#w.connect("create_projectile", self, "create_projectile")
		$Weapons.add_child(w)
	
	var cameras = get_tree().get_nodes_in_group("camera")
	camera = cameras[0]
	$Label.text = "Player %s" % player_id
	$AnimatedSprite.animation = "p%s_walk" % player_id

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('p%s_right' % player_id):
		input.x += 1
		$AnimatedSprite.flip_h = true
		direction.x = input.x
	if Input.is_action_pressed('p%s_left' % player_id):
		input.x -= 1
		$AnimatedSprite.flip_h = false
		direction.x = input.x
	if Input.is_action_pressed('p%s_down' % player_id):
		input.y += 1
		
	if Input.is_action_pressed('p%s_up' % player_id):
		input.y -= 1
		
	
	if input == Vector2.ZERO:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1
	else:
		$AnimatedSprite.play()
	return input


func _process(delta):
	if flash > 0:
		$AnimatedSprite.modulate = Color(100,100,100,100)
		self.flash -= 1
		speed = base_speed / 2
		
	var direction = get_input()
	speed = lerp(speed, base_speed, 0.2)
	
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	if camera.max_pos:
		position.x = clamp(position.x, camera.min_pos.x, camera.max_pos.x)
		position.y = clamp(position.y, camera.min_pos.y, camera.max_pos.y)
	
	

func _physics_process(delta):
	var enemies = $Hurtbox.get_overlapping_areas()
	for e in enemies:
		take_damage(1)

func create_projectile(p,local=false):
	if not local:
		owner.call_deferred("add_child", p)
	else:
		call_deferred("add_child", p)

func _on_ItemRange_area_entered(area):
	if area is Item and not area.target:
		area.target = self

func _on_ItemPickup_area_entered(area):
	if area is Item:
		area.collect()

func set_hp(val):
	hp = clamp(val, 0, max_hp)
	health_bar.value = hp

func set_max_hp(val):
	max_hp = val
	health_bar.max_value = max_hp

func _on_Hurtbox_area_entered(area):
	pass # self.hp -= 1
	pass # take_damage

func take_damage(amt):
	if not iframes_active:
		self.flash = 15
		self.hp -= amt
		iframes_active = true
		$IFrames.start()

func _on_IFrames_timeout():
	iframes_active = false
	speed = base_speed

func set_flash(val):
	flash = val
	if flash == 0:
		$AnimatedSprite.modulate = Color.white

func get_weapons():
	return $Weapons.get_children()

func _on_RegenTimer_timeout():
	self.hp += regen_amt
