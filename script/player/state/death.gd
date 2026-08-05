class_name PlayerStateDeath extends PlayerState

const DEATH_AUDIO = preload("uid://cgdamr0xqguc3")

# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play("death")
	Audio.play_spatial_sound(DEATH_AUDIO, player.global_position)
	Audio.play_music(null)
	await player.animation_player.animation_finished
	PlayerHud.show_game_over()
	pass


#what happens when we exit this state?
func exit()-> void:
	
	pass


# what happens when an input is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	
	return null


# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	
	return null


# what happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	return null
