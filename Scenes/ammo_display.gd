extends Label

var ammo_in_shotgun_mag = self.get_parent().get_parent().get_parent().ammo_in_shotgun
var ammo_in_pistol_mag = self.get_parent().get_parent().get_parent().ammo_in_pistol
var ammo_in_rifle_mag = self.get_parent().get_parent().get_parent().ammo_in_rifle

var rifleammo_in_pocket = self.get_parent().get_parent().get_parent().total_rifle_ammo
var pistolammo_in_pocket = self.get_parent().get_parent().get_parent().total_pistol_ammo
var shotgunammo_in_pocket = self.get_parent().get_parent().get_parent().total_shotgun_ammo

var weapon_type: String = "pistol"

func _ready() -> void:
	pass
		
func _process(delta: float) -> void:
	ammo_in_shotgun_mag = self.get_parent().get_parent().get_parent().ammo_in_shotgun
	ammo_in_pistol_mag = self.get_parent().get_parent().get_parent().ammo_in_pistol
	ammo_in_rifle_mag = self.get_parent().get_parent().get_parent().ammo_in_rifle
	
	rifleammo_in_pocket = self.get_parent().get_parent().get_parent().total_rifle_ammo
	pistolammo_in_pocket = self.get_parent().get_parent().get_parent().total_pistol_ammo
	shotgunammo_in_pocket = self.get_parent().get_parent().get_parent().total_shotgun_ammo
	
	var switch = get_parent().get_node("Weapon_display").Weapon
	
	match get_parent().get_node("Weapon_display").Weapon:
		"rifle":
			text = "Ammo: %d / %d" % [ammo_in_rifle_mag, rifleammo_in_pocket]
		"pistol":
			text = "Ammo: %d / %d" % [ammo_in_pistol_mag, pistolammo_in_pocket]
		"shotgun":
			text = "Ammo: %d / %d" % [ammo_in_shotgun_mag, shotgunammo_in_pocket]
	
