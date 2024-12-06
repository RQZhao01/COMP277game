# win_screen.gd
extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var main_menu_scene = preload("res://Scenes/main.tscn")
