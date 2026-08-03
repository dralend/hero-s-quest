@icon("res://assets/icons/damage_area.svg")
class_name DamageArea extends Area2D

signal damage_taken(attack_area)

@export var audio: AudioStream


func _ready() -> void:
	
	pass


func take_damage(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
	print("damage", attack_area.damage)
	if audio:
		Audio.play_spatial_sound(audio, global_position)
	pass


func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	pass
