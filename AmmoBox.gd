extends Container

onready var ammo_label = $Label

func _on_Player_ammo_changed(ammo):
	ammo_label.text = "AMMO " + str(ammo)