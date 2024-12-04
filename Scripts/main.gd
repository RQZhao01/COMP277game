extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	print("play button pressed")
	var level_1 = load("res://Scenes/MaxsLevel.tscn")
	var level_1_scene = level_1.instantiate()
	print(get_tree())
	

func _on_load_button_pressed() -> void:
	pass # Replace with function body.
