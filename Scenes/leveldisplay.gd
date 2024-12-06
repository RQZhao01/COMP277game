extends Label
var variable = 1

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	variable = get_parent().get_parent().get_parent().level
	if variable == 1:
		text = "LEVEL 1"
		
	elif variable == 2:
		text = "LEVEL 2"
		
	elif variable == 3:
		text = "LEVEL 3"
	else:
		pass
