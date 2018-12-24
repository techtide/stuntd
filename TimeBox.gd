extends Container

onready var timer = get_node("../../WaveManager/Timer")
onready var time_label = $Label

func _process(delta):
	time_label.text = "0:" + str(int(timer.time_left))