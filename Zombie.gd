extends KinematicBody2D

const MOVE_SPEED = 200

onready var raycast = $RayCast2D

onready var grave_scn = preload("res://Grave.tscn")

var player = null

func _ready():
	add_to_group("zombies")

func _physics_process(delta):
	if player == null:
		player = get_node("../Player")
	
	var vec_to_player = player.global_position - self.global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	var collision = move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if collision != null && collision.collider != null && collision.collider.has_method("damage_health"):
		collision.collider.damage_health(2)
	
	if collision != null && collision.collider != null && collision.collider.is_in_group("turret"):
		move_and_collide(delta * Vector2(-5, -5) * MOVE_SPEED)

func kill():
	# We want to store the position of the player where it died, remove the player, and draw a grave in that area.
	var death_position = self.global_position
	queue_free()
	var grave = grave_scn.instance()
	grave.set_position(death_position)
	get_parent().add_child(grave)

func kill_shoot():
	queue_free()

func set_player(p):
	player = p