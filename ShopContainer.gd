extends Container

var is_visible = false

signal edit_mode()
signal edit_mode_off() # relay this signal back when editing is done, so the scripts can set edit_mode back to false

onready var money_label = get_node("../Canvas/MoneyBox/Label")
onready var taser_turret_scn = preload("res://StunTurret.tscn")
onready var gun_turret_scn = preload("res://KillTurret.tscn")
onready var shield_scn = preload("res://Shield.tscn")

var money = 50.00
var money_per_kill = 10
var edit_mode = false
var item = null

enum ITEM_TYPE {
	powerup,
	object,
}

var items = {
	TASER_TURRET = {
		name = "Taser Turret",
		price = 400.00,
		asset = preload("res://StunTurret.tscn"),
		type = ITEM_TYPE.object,
	},
	GUN_TURRET = {
		name = "Gun Turret",
		price = 1000.00,
		asset = preload("res://KillTurret.tscn"),
		type = ITEM_TYPE.object,
	},
	SHIELD = {
		name = "Damage Shield",
		price = 300.00,
		asset = preload("res://Shield.tscn"),
		type = ITEM_TYPE.powerup,
	},
	HUNDREDHP = {
		name = "150 HP",
		price = 150.00,
		asset = null,
		type = ITEM_TYPE.powerup
	},
	THREEAMMO = {
		name = "Three Ammo",
		price = 70.00,
		asset = null,
		type = ITEM_TYPE.powerup,
	},
}

func _ready():
	self.visible = false
	is_visible = false

func _process(delta):
	if edit_mode and item.type == ITEM_TYPE.object:
		if Input.is_action_pressed("build_location_pressed"):
			var pos = get_global_mouse_position()
			var item_instance = item.asset.instance()
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
	if money < items[item_name].price:
		print("You cannot buy this item!")
	else:
		money -= items[item_name].price
		self.visible = false
		item = items[item_name]
		
		#################### Execute functions of store-bought items #################### 
		if item.type == ITEM_TYPE.object:
			emit_signal("edit_mode")
			edit_mode = true
		elif item.name == "Damage Shield":
			var ply = get_node("../Player")
			var shield = item.asset.instance()
			shield.position = Vector2(0, 0)
			ply.add_child(shield)
		elif item.name == "100 HP":
			var ply = get_node("../Player")
			ply.reset_health()
		elif item.name == "Three Ammo":
			var ply = get_node("../Player")
			ply.add_three_ammo()

func _on_Player_player_killed():
	money += money_per_kill
	money_label.text = "$" + str(money)