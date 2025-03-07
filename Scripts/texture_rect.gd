extends TextureRect

signal weapon_type1
signal weapon_type2
signal weapon_type3

var weapon_textures = {
	"pistol": preload("res://Assets/gun.png"),
	"shotgun": preload("res://Assets/pump-shotgun.png"),
	"rifle": preload("res://Assets/rifle.png")}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon_textures = {
	"pistol": preload("res://Assets/gun.png"),
	"shotgun": preload("res://Assets/pump-shotgun.png"),
	"rifle": preload("res://Assets/rifle.png")
}
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_survivor_weapon_changed(weapon: String) -> void:
	if weapon == "pistol":
		texture = weapon_textures["pistol"]
		emit_signal("weapon_type1")
	elif weapon == "rifle":
		texture = weapon_textures["rifle"]
		emit_signal("weapon_type2")
	elif weapon == "shotgun":
		texture = weapon_textures["shotgun"]
		emit_signal("weapon_type3")
	else:
		pass
	pass # Replace with function body.
