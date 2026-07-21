extends Node


var current_slot: int = 0
var save_data: Dictionary
var discovered_areas: Array = []
var persistent_data: Dictionary = {}


func _ready() -> void:
	
	pass


func create_new_game_save() -> void:
	var new_game_scene: String = "uid://q4je7fq7nedp"
	save_data = {
		"scene_path": new_game_scene,
		"x": 20,
		"y": 255,
		"hp": 20,
		"max_hp": 20,
		"dash": false,
		"double_jump": false,
		"ground_slam": false,
		"morph_roll": false,
		"discovered_areas": [new_game_scene],
		"persistent_data": {},
		
	}
	pass


func save_game() -> void:
	
	pass


func load_game() -> void:
	
	pass
