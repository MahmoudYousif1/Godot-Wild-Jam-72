extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String
@onready var animation_player = $AnimationPlayer
@onready var loading = $menuElements/Loading


func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)
	animation_player.play("fade")
	await animation_player.animation_finished
	animation_player.play("load")


func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(3.0).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		animation_player.play_backwards("fade")
		await animation_player.animation_finished
		get_tree().change_scene_to_packed(new_scene)
