class_name Player extends CharacterBody2D

#region /// signals
signal damage_taken
#endregion

#region /// export variables
@export var move_speed: float = 150
@export var max_fall_velocity: float = 600
#endregion

#region /// on ready variables

@onready var attack_sprite: Sprite2D = $Sprite2D/AttackSprite2D
@onready var sprite: PlayerSprite = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var da_stand: CollisionShape2D = $DamageArea/DAStand
@onready var da_crouch: CollisionShape2D = $DamageArea/DACrouch
@onready var animation_player: AnimationPlayer = $stuff/AnimationPlayer
@onready var one_way_platrorm_shape_cast: ShapeCast2D = $stuff/OneWayPlatrormShapeCast
@onready var attack_area: AttackArea = %AttackArea
@onready var damage_area: DamageArea = %DamageArea

#endregion

#region /// state machine variables
var states: Array [PlayerState]
var current_state: PlayerState: 
	get: return states.front()
var previous_state: PlayerState: 
	get: return states[1]
#endregion

#region /// player stats
var hp: float = 20:
	set(value):
		hp = clampf(value, 0, max_hp)
		MessageBus.player_health_changed.emit(hp, max_hp)
var max_hp: float = 20:
	set(value):
		max_hp = value
		MessageBus.player_health_changed.emit(hp, max_hp)
var dash: bool = false
var dash_count: int = 0
var double_jump: bool = false
var jump_count: int = 0
var ground_slam: bool = false
var morph_roll: bool = false
#endregion

#region /// standard variables
var direction: Vector2 = Vector2.ZERO
var gravity: float = 980
var gravity_mulitplier: float = 1.0
#endregion



func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	initialize_states()
	self.call_deferred("reparent", get_tree().root)
	MessageBus.player_healed.connect(_on_player_healed)
	damage_area.damage_taken.connect(_on_damage_taken)
	hp = max_hp
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y *= .05
	if event.is_action_pressed("action"):
		MessageBus.player_interacted.emit(self)
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu: PauseMenu = load("uid://bxwjf8xin2q1i").instantiate()
		add_child(pause_menu)
		return
	
	if OS.is_debug_build():
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_MINUS:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp -= 10
				else:
					hp -= 2
			elif event.keycode == KEY_EQUAL:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp += 10
				else:
					hp += 2
	
	change_state(current_state.handle_input(event))

func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))
	pass


func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta * gravity_mulitplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	move_and_slide()
	change_state(current_state.physics_process(_delta))
	pass


func initialize_states() -> void:
	states = []
	
	for c in $states.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
		pass
	if states.size() == 0:
		return
	
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	$stuff/Label.text = current_state.name
	pass


func change_state(new_state: PlayerState) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	if current_state:
		current_state.exit()
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)
	$stuff/Label.text = current_state.name
	pass


func update_direction() -> void:
	var prev_direction: Vector2 = direction
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	if prev_direction.x != direction.x:
		attack_area.flip(direction.x)
		if direction.x < 0:
			sprite.flip_h = true
			attack_sprite.flip_h = true
			attack_sprite.position.x = -24
		elif direction.x > 0:
			sprite.flip_h = false
			attack_sprite.flip_h = false
			attack_sprite.position.x = 24
	pass


func _on_player_healed(amount: float) -> void:
	hp += amount
	pass


func _on_damage_taken(a: AttackArea) -> void:
	if current_state == PlayerStateDeath:
		return
	hp -= a.damage
	damage_taken.emit()
	pass


func can_dash() -> bool:
	if dash == false or dash_count > 0:
		return false
	return true


func can_morph() -> bool:
	if morph_roll == false:
		return false
	return true
