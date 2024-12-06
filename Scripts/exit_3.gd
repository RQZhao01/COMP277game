extends Area2D

# Load the win_screen scene
@onready var win_screen_scene = preload("res://Scenes/win_screen.tscn")

func _on_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		var win_screen_instance = win_screen_scene.instantiate()
		get_tree().root.add_child(win_screen_instance)
		get_tree().current_scene.queue_free()
