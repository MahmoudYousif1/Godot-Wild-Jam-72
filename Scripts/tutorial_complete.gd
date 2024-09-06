extends Control

@onready var label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var animation_player = $AnimationPlayer

func _ready():
	ClickSound.play_menu_music()
	animation_player.play("fade")
	label.text = "Hearts Collected: " + str(Global.completedHearts) + " / " + str(Global.max_hearts1)

	
func _process(_delta):
	label.text = "Hearts Collected: " + str(Global.completedHearts) + " / " + str(Global.max_hearts1)



func _on_go_menu_pressed():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/LevelsLoadingScreen.tscn")
