extends Control

@onready var animation_player = $AnimationPlayer
@onready var back = $PanelContainer/MarginContainer/HBoxContainer/AnimatedSprite2D/Back


func _ready():
	animation_player.play("fade")
	ClickSound.play_menu_music()

func _on_back_pressed():
	ClickSound.playClick()
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/menu_loading_screen.tscn")



func _on_lvl_1_pressed():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")




func _on_lvl_2_pressed():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")




func _on_lvl_3_pressed():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")

