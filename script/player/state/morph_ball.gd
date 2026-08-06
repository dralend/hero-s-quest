class_name PlayerStateMorphball extends PlayerState

const MORPH_AUDIO = preload("uid://4fost2sryytg")
const MORPH_OUT_AUDIO = preload("uid://cwit3nrsoplu1")

@export var jump_velocity: float = 400

var on_floor: bool = true

@onready var ball_ray_up: RayCast2D = %BallRayUp
@onready var ball_ray_down: RayCast2D = %BallRayDown
@onready var jump_audio: AudioStreamPlayer2D = %JumpAudio
@onready var land_audio: AudioStreamPlayer2D = %landAudio


# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play("ball")
	var shape: CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 10.0
	shape.height = 20.0
	player.collision_stand.position.y = -10
	player.da_stand.position.y = -10
	player.velocity.y -= 100
	Audio.play_spatial_sound(MORPH_AUDIO,player.global_position)
	
	pass


#what happens when we exit this state?
func exit()-> void:
	player.animation_player.speed_scale = 1
	var shape: CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 8.0
	shape.height = 46.0
	player.collision_stand.position.y = -23
	player.da_stand.position.y = -23
	player.velocity.y -= 100
	Audio.play_spatial_sound(MORPH_OUT_AUDIO,player.global_position)
	pass


# what happens when an input is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("ball"):
		if _can_stand():
			if player.is_on_floor():
				return idle
			return fall
	if _event.is_action_pressed("jump"):
		if player.is_on_floor():
			if Input.is_action_pressed("down"):
				player.one_way_platrorm_shape_cast.force_shapecast_update()
				if player.one_way_platrorm_shape_cast.is_colliding():
					player.position.y += 4
					return null
			player.velocity.y -= jump_velocity
			jump_audio.play()
			VisualEffects.jump_dust(player.global_position)
	return next_state


# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		player.animation_player.speed_scale = 0
	else:
		player.animation_player.speed_scale = 1
	return next_state


# what happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust(player.global_position)
			land_audio.play()
	return next_state


func _can_stand() -> bool:
	ball_ray_up.force_raycast_update()
	ball_ray_down.force_raycast_update()
	if ball_ray_down.is_colliding() and ball_ray_up.is_colliding():
		return false
	return true
