extends Area2D

@onready var collect_sound = $collectSound
var collected = false

func _on_body_entered(body):
	if body.is_in_group("player") and not collected:
		if Global.total_hearts < Global.max_hearts1:
			collected = true
			Global.total_hearts += 1
			collect_sound.play()
			queue_free()

			# Update completedHearts whenever a heart is collected
			Global.completedHearts = Global.total_hearts
		else:
			pass
