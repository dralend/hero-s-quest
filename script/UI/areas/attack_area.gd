@icon("res://assets/icons/attack_area.svg")
class_name AttackArea extends Area2D







func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	monitorable = false
	monitoring = true
	pass


func _on_body_entered(body: Node2D) -> void:
	print("hit")
	if body is DamageArea:
		print("damage")
	pass























#
