class_name PauseMenu extends CanvasLayer


#region /// on ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system_screen: Control = %SystemScreen
@onready var system_menubut: Button = %SystemMenuButton
@onready var back_to_map_but: Button = %BackToMapButton
@onready var back_to_title_but: Button = %BackToTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player_position: Vector2


func _ready() -> void:
	
	show_pause_screen()
	system_menubut.pressed.connect(show_system_menu)
	Audio.setup_button_audio(self)
	set_system_menu()
	var player: Node2D = get_tree().get_first_node_in_group("Player")
	if player:
		player_position = player.global_position
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menubut.grab_focus()
	pass


func show_pause_screen() -> void:
	pause_screen.visible = true
	system_screen.visible = false
	
	pass


func show_system_menu() -> void:
	pause_screen.visible = false
	system_screen.visible = true
	back_to_map_but.grab_focus()
	pass


func set_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	ui_slider.value_changed.connect(_on_ui_slider_changed)
	
	back_to_map_but.pressed.connect(show_pause_screen)
	back_to_title_but.pressed.connect(_on_back_to_title_pressed)
	pass


func _on_back_to_title_pressed() -> void:
	
	SceneManager.transition_scene("uid://dcdm5tbsn1add", "", Vector2.ZERO, "up")
	get_tree().paused = false
	queue_free()
	pass


func _on_music_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(2, v)
	SaveManager.save_configuration()
	pass


func _on_sfx_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	Audio.play_spatial_sound(Audio.ui_focus_audio, player_position)
	SaveManager.save_configuration()
	pass


func _on_ui_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(4, v)
	Audio.ui_focus_change()
	SaveManager.save_configuration()
	pass
