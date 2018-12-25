extends Area2D

onready var timer = $Timer

func _ready():
	# put timer etc in here
	# 45 seconds means that the shield will last for 3 rounds.
	get_parent().shield_on()

func _on_Timer_timeout():
	get_parent().shield_off()
	queue_free()