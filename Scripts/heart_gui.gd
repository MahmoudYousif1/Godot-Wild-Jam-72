extends CanvasLayer

@onready var label = $Label

func _process(delta):
	
	label.text = "Hearts: " + str(Global.total_hearts2) + "/" + str(Global.max_hearts2)
