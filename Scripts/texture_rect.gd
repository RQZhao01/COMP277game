extends TextureRect

var weapon_textures = {
	"pistol": preload("res://Assets/gun.png"),
	"shotgun": preload("res://Assets/pump-shotgun.png"),
	"rifle": preload("res://Assets/rifle.png")}
var Weapon = "pistol"

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
		Weapon = "pistol"
	elif weapon == "rifle":
		texture = weapon_textures["rifle"]
		Weapon = "rifle"
	elif weapon == "shotgun":
		texture = weapon_textures["shotgun"]
		Weapon ="shotgun"
	
	else:
		pass
	pass # Replace with function body.
