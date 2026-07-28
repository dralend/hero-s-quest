class_name PauseMenu extends CanvasLayer


#region /// on ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system_screen: Control = %SystemScreen
@onready var system_menu: Button = %SystemMenu
@onready var back_to_map_but: Button = %BackToMapBut
@onready var back_to_title_but: Button = %BackToTitleBut
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player: Player


func _ready() -> void:
	
	show_pause_screen()
	system_menu.pressed.connect(show_system_menu)
	
	set_system_menu()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menu.grab_focus()
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
	
	back_to_map_but.pressed.connect(show_pause_screen)
	back_to_title_but.pressed.connect(_on_back_to_title_pressed)
	pass


func _on_back_to_title_pressed() -> void:
	
	SceneManager.transition_scene("uid://dcdm5tbsn1add", "", Vector2.ZERO, "up")
	get_tree().paused = false
	queue_free()
	pass
