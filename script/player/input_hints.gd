@icon("res://assets/icons/input_hints.svg")
class_name InputHints extends Node2D


const HINT_MAP: Dictionary ={
	"keyboard": {
		"interact": 0,
		"attack": 0,
		"jump": 0,
		"dash": 0,
		"up": 0
	},
	"xbox": {
		"interact": 5,
		"attack": 6,
		"jump": 7,
		"dash": 8,
		"up": 4
	},
	"playstation": {
		"interact": 1,
		"attack": 3,
		"jump": 0,
		"dash": 2,
		"up": 4
	},
	"nintendo": {
		"interact": 6,
		"attack": 5,
		"jump": 8,
		"dash": 7,
		"up": 4
	}
}
var controller_type: String = "keyboard"

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	visible = false
	MessageBus.input_hint_changed.connect(_on_hint_changed)
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type(event.device)
	pass


func get_controller_type(device_id: int) -> void:
	var n: String = Input.get_joy_name(device_id).to_lower()
	if "xbox" in n:
		controller_type = "xbox"
	elif "playstation" in n or "ps" in n or "dualsense" in n:
		controller_type = "playstation"
	elif "nintendo" in n or "switch" in n:
		controller_type = "nintendo"
	else:
		controller_type = "unkown"
		print(controller_type)
	set_process_input(false)
	pass


func _on_hint_changed(hint: String) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		
	pass
