class_name PlayerStateFall extends PlayerState



# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	
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
	return next_state
