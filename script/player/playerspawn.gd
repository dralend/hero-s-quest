@icon("res://assets/player/player_spawn.svg")
class_name playerspawn extends Node2D

const PLAYER = preload("uid://bgjl4v7ef6snl")


func _ready() -> void:
	visible = false
	await get_tree().process_frame
	if get_tree().get_first_node_in_group("Player"):
		return
	var player: Player = load("uid://bgjl4v7ef6snl").instantiate()
	get_tree().root.add_child(player)
	player.global_position = self.global_position
	pass
