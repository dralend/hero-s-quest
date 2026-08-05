class_name PlayerStateGroundSlam extends PlayerState

const DASH_AUDIO = preload("uid://dmg8ec6qcvcmp")

@export var velocity: float = 400
@export var effect_delay: float = 0.075

var effect_timer: float = 0


# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play("ground_slam")
	player.sprite.tween_color()
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	pass


#what happens when we exit this state?
func exit()-> void:
	
	pass


# what happens when an input is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	
	return next_state


# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	
	return next_state


# what happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	
	return next_state
