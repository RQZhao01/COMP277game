extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().move_speed == 250:
		$Noisecircleshape.scale =  Vector2(50,50)
		$Sprite2DNoiseCircle.scale = Vector2(0.054,0.054)
	
	elif get_parent().move_speed == 125:
		$Noisecircleshape.scale =  Vector2(25,25)
		$Sprite2DNoiseCircle.scale = Vector2(0.027,0.027)
	
	elif get_parent().move_speed == 500:
		$Noisecircleshape.scale = Vector2(100,100)
		$Sprite2DNoiseCircle.scale = Vector2(0.108,0.108)
	pass
