extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	ClickSound.play_menu_music()
	animation_player.play("fade")
	get_tree().paused = false
	set_process_input(true)
	self.hide()

func pause():
	# Play fade in animation when pausing
	animation_player.play("fade")
	get_tree().paused = true
	self.show()

func resuming():
	animation_player.play_backwards("fade")
	get_tree().paused = false
	self.hide()

func go_menu():
	animation_player.play_backwards("fade")
	get_tree().paused = false
	self.hide()
	get_tree().change_scene_to_file("res://Scenes/menu_loading_screen.tscn")

func _input(event):
	if event.is_action_pressed("pause"):
		if !get_tree().paused:
			pause()
		else:
			resuming()

func _on_resume_pressed():
	resuming()

func _on_options_pressed():
	pass # Replace with function body.

func _on_levels_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_menu_pressed():
	go_menu()

func _on_restart_pressed():
	get_tree().paused = false
	self.hide()
	Global.total_hearts = 0
	get_tree().reload_current_scene()
