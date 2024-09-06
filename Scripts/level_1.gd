extends Node2D

@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("fade")
	ClickSound.stop_music()

func _on_area_2d_body_entered(body):
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Level1Complete.tscn")
