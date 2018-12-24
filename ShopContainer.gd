extends Container

var is_visible = false

signal edit_mode()
signal edit_mode_off() # relay this signal back when editing is done, so the scripts can set edit_mode back to false

onready var money_label = get_node("../Canvas/MoneyBox/Label")
onready var taser_turret_scn = preload("res://StunTurret.tscn")
onready var gun_turret_scn = preload("res://KillTurret.tscn")

var money = 50.00
var money_per_kill = 10
var edit_mode = false
var item = null

var items = {
	TASER_TURRET = {
		name = "Taser Turret",
		price = 10.00,
		asset = preload("res://StunTurret.tscn"),
	},
	GUN_TURRET = {
		name = "Gun Turret",
		price = 10.00,
		asset = preload("res://KillTurret.tscn"),
	}
}

func _ready():
	self.visible = false
	is_visible = false
	print(items)

func _process(delta):
	if edit_mode:
		if Input.is_action_pressed("build_location_pressed"):
			var pos = get_global_mouse_position()
			var item_instance = item.instance()
			item_instance.position = Vector2(pos.x, pos.y)
			get_parent().add_child(item_instance)
			
			edit_mode = false
			item = null
			emit_signal("edit_mode_off")

func _input(event):
	if event.is_action_pressed("open_shop") and !is_visible:
		self.visible = true
		is_visible = true
	elif event.is_action_pressed("open_shop") and is_visible:
		self.visible = false
		is_visible = false

func purchase(item_name):
	money -= items[item_name].price
	self.visible = false
	emit_signal("edit_mode")
	item = items[item_name].asset
	edit_mode = true

func _on_Player_player_killed():
	money += money_per_kill
	money_label.text = "$" + str(money)