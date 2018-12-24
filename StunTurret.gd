extends KinematicBody2D

onready var raycast = $Sprite/RayCast2D

onready var line = $Sprite/LineEmitter/Line2D
onready var line_holder = $Sprite/LineHolder

onready var timer = $Timer

onready var sprite = $Sprite

func _ready():
	add_to_group("turret")

func _process(delta):
	aim(get_closest_zombie())
	if int(timer.time_left) == 0:
		timer.stop()
		stun_shoot()
		timer.wait_time = 10
		timer.start()

func get_closest_zombie():
	var targets = get_tree().get_nodes_in_group("zombies")
	var closest_zombie = Vector2(100000, 100000)
	for zombie in targets:
		var vec_to_zombie = zombie.global_position - self.global_position
		if vec_to_zombie.length_squared() < closest_zombie.length_squared():
			closest_zombie = vec_to_zombie
	return closest_zombie

func aim(zombie):
	if zombie == Vector2(100000, 100000):
		# Do the pan animation
		pass
		sprite.global_rotation += 0.01
	else:
		var rotation = atan2(zombie.y, zombie.x)
		sprite.global_rotation = rotation

func stun_shoot():
	# This shoots the zombies with a stun gun, causing them to be killed. For the "Taser Turret"
	var coll = raycast.get_collider()
	if raycast.is_colliding() and coll != null and coll.has_method("kill"):
		line.add_point(raycast.get_collision_point())
		coll.kill()	
		for i in range(0, line.points.size()):
			yield(get_tree().create_timer(0.1), "timeout")
			line.remove_point(i)