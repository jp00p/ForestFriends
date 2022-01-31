extends KinematicBody2D

class_name Enemy

signal drop_item(item, where)

var players = null
var chasing = null
var onscreen = false
export (int) var chase_speed = 40
export (int) var hp = 1 setget set_hp
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var player_direction = Vector2.ZERO
var flash = 0 setget set_flash
var colliding = false
var push_vector = Vector2.ZERO

onready var xp_gem = preload("res://items/XPGem.tscn")
onready var floating_text = preload("res://UI/FloatingText.tscn")

func _ready():
	players = get_tree().get_nodes_in_group("players")
	chasing = players[randi() % players.size()]
	$Sprite.frame = rand_range(0, 2)
	# TODO switch targets when inital target dies
	
func _process(delta):
	var velocity = Vector2.ZERO
	
	
	if flash > 0:
		$Sprite.modulate = Color(100,100,100,100)
		self.flash -= 1
		knockback = knockback.move_toward(Vector2.ZERO, 100 * delta)
		knockback = move_and_slide(knockback)
	elif chasing:
		player_direction = (chasing.position - self.position).normalized()
		$Sprite.flip_h = !chasing.global_position.x < self.global_position.x
		if colliding:
			velocity += push_vector * 16 * delta
		velocity += global_position.move_toward(chasing.position, delta * chase_speed)
		#global_position = velocity
		velocity = move_and_slide(chase_speed * player_direction)

func take_damage(amt, knockback_vector):
	self.flash = 6
	create_damage_text(amt)
	knockback = knockback_vector * 300
	self.hp = self.hp - amt

func set_hp(val):
	hp = val
	if hp <= 0:
		death()

func death():
	if randi() % 3 == 1:
		emit_signal("drop_item", xp_gem, global_position)
	queue_free()

func set_flash(val):
	flash = val
	if flash == 0:
		$Sprite.modulate = Color.white

func create_damage_text(dmg):
	var ft = floating_text.instance()
	ft.text = str(dmg)
	add_child(ft)



func _on_VisibilityNotifier2D_screen_entered():
	$CollisionShape2D.set_deferred("disabled", false)


func _on_VisibilityNotifier2D_screen_exited():
	$CollisionShape2D.set_deferred("disabled", true)

