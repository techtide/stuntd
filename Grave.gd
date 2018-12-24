extends Node2D

onready var timer = get_node("Timer")
onready var zombie_scn = preload("res://Zombie.tscn")
var font = DynamicFont.new()

func _ready():
	font.size = 17
	font.set_font_data(load("res://RobotoMono.ttf"))
	update()
	pass

func _process(delta):
	if int(timer.time_left) == 0:
		rebirth()
	update()

func _draw():
	draw_string(font, Vector2(-4.5,5.5), str(int(timer.time_left)))

func rebirth():
	var grave_position = self.global_position
	queue_free()
	var zombie = zombie_scn.instance()
	zombie.set_position(grave_position)
	get_parent().add_child(zombie)