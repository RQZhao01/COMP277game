extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var survivor = get_parent().get_parent().get_parent()
	

	survivor.connect("medkit_change", Callable(self, "_on_survivor_medkit_change"))


func _on_survivor_medkit_change() -> void:
	var medkit_num = get_parent().get_parent().get_parent().medkit_count
	
	text = "%d" % [medkit_num]
