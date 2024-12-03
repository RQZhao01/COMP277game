extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	


	var weapon_display = get_parent().get_node("Weapon_display")
	
	if weapon_display:
		weapon_display.connect("weapon_type1", Callable(self, "_on_weapon_type_1"))
		weapon_display.connect("weapon_type2", Callable(self, "_on_weapon_type_2"))
		weapon_display.connect("weapon_type3", Callable(self, "_on_weapon_type_3"))
		

func _on_weapon_display_weapon_type_1() -> void:
	var pistol_ammo_in_gun = get_parent().get_parent().get_parent().ammo_in_pistol
	var pistol_ammo_pocket = get_parent().get_parent().get_parent().total_pistol_ammo
	text = "%d / %d" % [pistol_ammo_in_gun,pistol_ammo_pocket]
	pass # Replace with function body.


func _on_weapon_display_weapon_type_2() -> void:
	var rifle_ammo_in_gun = get_parent().get_parent().get_parent().ammo_in_rifle
	var rifle_ammo_pocket = get_parent().get_parent().get_parent().total_rifle_ammo
	text = "%d / %d" % [rifle_ammo_in_gun,rifle_ammo_pocket]
	pass # Replace with function body.


func _on_weapon_display_weapon_type_3() -> void:
	
	var shotgun_ammo_in_gun = get_parent().get_parent().get_parent().ammo_in_shotgun
	var shotgun_ammo_pocket = get_parent().get_parent().get_parent().total_shotgun_ammo
	text = "%d / %d" % [shotgun_ammo_in_gun,shotgun_ammo_pocket]
	
	
	pass # Replace with function body.
