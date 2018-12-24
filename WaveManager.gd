extends Node

signal wave_changed(wave)

var current_wave = 1

onready var wave_timer = $Timer
onready var zombie_scn = preload("res://Zombie.tscn")
onready var ammo_scn = preload("res://Ammo.tscn")
onready var time_label = get_node("../Canvas/TimeBox/Label")

var edit_mode = false

func _ready():
	wave_timer.start()

func _process(delta):
	while int(wave_timer.time_left) <= 0:
		# Increment the wave, reset the timer to the new wave's time, and spawn zombies and ammo.
		wave_timer.stop()
		increment_wave()
		wave_timer.wait_time = 5+(5*(current_wave-1))
		spawn_zombies()
		wave_timer.start()
		spawn_ammo()
	pass

func get_zombie_count(wave):
	# This is the number of zombies to add. Not the total number of zombies.
	return 1

func increment_wave():
	current_wave += 1
	emit_signal("wave_changed", current_wave)

func spawn_zombies():
	var amount = get_zombie_count(current_wave)
	for i in range(0, amount):	
		var zombie = zombie_scn.instance()
		var x = rand_range(3, get_viewport().get_visible_rect().size.x-3)
		var y = rand_range(3, get_viewport().get_visible_rect().size.y-3)
		zombie.position = Vector2(x, y)
		get_parent().add_child(zombie)

func spawn_ammo():
	for i in range(0, rand_range(1, 3)):
		var ammo = ammo_scn.instance()
		var sizex = get_viewport()
		var x = rand_range(3, get_viewport().get_visible_rect().size.x-3)
		var y = rand_range(3, get_viewport().get_visible_rect().size.y-3)
		ammo.position = Vector2(x, y)
		get_parent().add_child(ammo)

func _on_ShopContainer_edit_mode():
	edit_mode = true
	wave_timer.stop()
	time_label.add_color_override("font_color", Color("#ff4500"))

func _on_ShopContainer_edit_mode_off():
	edit_mode = false
	wave_timer.start()
	time_label.add_color_override("font_color", Color("#ffffff"))
