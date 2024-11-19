extends AudioStreamPlayer2D


func _ready() -> void:
	self.play()

func _process(delta: float) -> void:
	pass

func _on_finished() -> void:
	get_parent().remove_child(self)
