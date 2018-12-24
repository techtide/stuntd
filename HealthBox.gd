extends Container

onready var hp_label = $Label

func _on_Player_health_changed(health):
	hp_label.text = "HP " + str(health)
