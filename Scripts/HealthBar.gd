extends TextureProgressBar

@export var survivor: Survivor

func _ready():
	if survivor:
		survivor.current_health_changed.connect(update)
		update()
	else:
		print("not assigned")
	
func update():
	print("update")
	value = int(get_parent().current_health * 100 / get_parent().PLAYER_HP)


func _on_survivor_current_health_changed() -> void:
	print("?????")
	update()
	pass # Replace with function body.
