extends AudioStreamPlayer2D

var clicks = null
var current_music = null
var sound = preload("res://Assets/Sounds/abs-pointer-1.mp3")
var menu_music = preload("res://Assets/Music/Piano Instrumental 4- MainMenu.mp3")

func play_sound(sounds: AudioStream, volume = -23.129):
	if clicks == sounds:
		return
	clicks = sounds
	var player = AudioStreamPlayer.new()
	player.stream = sounds
	player.volume_db = volume
	player.autoplay = true
	add_child(player)
	player.play()

func playClick():
	play_sound(sound)


func play_music(music: AudioStream, volume = -33.129):
	if current_music == music:
		return
	current_music = music
	var player = AudioStreamPlayer.new()
	player.stream = music
	player.volume_db = volume
	player.autoplay = true
	add_child(player)
	player.play()

func play_menu_music():
	play_music(menu_music)

func stop_music():
	for player in get_children():
		if player is AudioStreamPlayer:
			player.stop()
			remove_child(player)
			player.queue_free()
	current_music = null
