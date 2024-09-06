extends Control


@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("fade")
	ClickSound.play_menu_music()

func _on_play_pressed():
	ClickSound.playClick()
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/TutorialLoadingScreen.tscn")



func _on_quit_pressed():
	ClickSound.playClick()
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().quit()


func _on_levels_pressed():
	ClickSound.playClick()
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/LevelsLoadingScreen.tscn")

