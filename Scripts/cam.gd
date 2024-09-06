extends Camera2D


const deadzone = 100

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.4
		if _target.length() < deadzone:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (_target.length() - deadzone)* 0.5
