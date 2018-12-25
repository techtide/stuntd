extends KinematicBody2D

const MOVE_SPEED = 300

onready var raycast = $RayCast2D

onready var line = get_node("LineEmitter/Line2D")
onready var line_holder = get_node("LineHolder")

onready var stungun_sfx = get_node("StunGunSFX")

var health = 100
var ammo = 6

var edit_mode = false

signal health_changed(health)
signal ammo_changed(ammo)
signal player_killed()

var shield = false

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	if !edit_mode:
		var move_vec = Vector2()
		if Input.is_action_pressed("move_up"):
			move_vec.y -= 1
		if Input.is_action_pressed("move_down"):
			move_vec.y += 1
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1
		move_vec = move_vec.normalized()
		move_and_collide(move_vec * MOVE_SPEED * delta)
		
		var look_vec = get_global_mouse_position() - global_position
		global_rotation = atan2(look_vec.y, look_vec.x)
		
		if Input.is_action_just_pressed("shoot"):
			var coll = raycast.get_collider()
			
			if ammo <= 0:
				print("No ammo!")
			else:
				ammo -= 1
			emit_signal("ammo_changed", ammo)
			
			if raycast.is_colliding() and coll.has_method("kill") and ammo > 0:
				coll.kill()
				line.points = PoolVector2Array()
				line.add_point(line_holder.global_position)
				line.add_point(raycast.get_collision_point())
				stungun_sfx.play(0)
				
				for i in range(0, line.points.size()):
					yield(get_tree().create_timer(0.1), "timeout")
					line.remove_point(i)
					
				emit_signal("player_killed")
	else:
		pass

func damage_health(amount):
	if edit_mode or shield:
		return
	else:
		health -= amount
		emit_signal("health_changed", health)
		if health <= 0:
			kill()

func increment_ammo():
	ammo += 3
	emit_signal("ammo_changed", ammo)

func kill():
	get_tree().reload_current_scene()

###################### Editing ######################

func _on_ShopContainer_edit_mode():
	print("[+] Edit mode turned on!")
	edit_mode = true

func _on_ShopContainer_edit_mode_off():
	print("[+] Edit mode turned off!")
	edit_mode = false

###################### Powerups ######################

func shield_on():
	print("shield")
	shield = true

func shield_off():
	shield = false

func reset_health():
	health = 100

func add_three_ammo():
	ammo += 3