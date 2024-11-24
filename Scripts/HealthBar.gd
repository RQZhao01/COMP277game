extends TextureProgressBar

@export var survivor: Survivor

func _ready():
	if survivor:
		survivor.current_health_changed.connect(update)
		update()
	else:
		print("not assigned")
	
func update():
	value = int(survivor.current_health * 100 / survivor.PLAYER_HP)


func _on_survivor_current_health_changed() -> void:
	pass # Replace with function body.
