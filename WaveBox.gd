extends Container

onready var wave_label = $Label

func _on_WaveManager_wave_changed(wave):
	wave_label.text = "WAVE " + str(wave)