extends Node2D

@onready var sign_button = $gameElements/sign/signButton
@onready var sign_text = $gameElements/sign/signText
@onready var animation_player = $AnimationPlayer
@onready var popup = $gameElements/sign/popup
@onready var popup_2 = $gameElements/sign2/popup2
@onready var popup_3 = $gameElements/sign3/popup3
@onready var popup_4 = $gameElements/sign4/popup4


func _ready():
	ClickSound.play_menu_music()
	animation_player.play("fade")
	await get_tree().create_timer(0.8).timeout
	animation_player.play("TutorialMusicFade")

func _on_sign_button_pressed():
	animation_player.play("signFade")
	popup.play()
	

func _on_sign_button_2_pressed():
	animation_player.play("signFade2")
	popup_2.play()


func _on_sign_button_3_pressed():
	animation_player.play("signFade3")
	popup_3.play()


func _on_sign_button_4_pressed():
	animation_player.play("signFade4")
	popup_4.play()


func _on_joke_1_pressed():
	animation_player.play("flamequestion")
	popup_2.play()

func _on_why_pressed():
	animation_player.play("flameAnswer")
	popup_2.play()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		animation_player.play_backwards("fade")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/tutorial_complete.tscn")
