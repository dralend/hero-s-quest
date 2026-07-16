class_name PlayerStateJump extends PlayerState

@export var jump_velocity: float = 450.0

# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	player.velocity.y -= jump_velocity
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
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	
	return next_state
