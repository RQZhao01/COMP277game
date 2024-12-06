extends Control

var current_level = "instance1"
var level = 1
signal death
var health = 100
var totalshotgunammo = 0
var totalrifleammo = 0
var totalpistolammo = 0
var ammoinrifle = 0
var ammoinpistol = 0
var ammoinshotgun = 0
var medkitcount = 0
var pop = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	#print(get_children())
	#print(current_level)
	
	if level == 2:
		
		var scene2_to_instance = preload("res://Scenes/level2.tscn")
		var instance2 = scene2_to_instance.instantiate()
		add_child(instance2)
		instance2.get_node("Survivor").current_health = get_node("MaxsLevel").get_node("Survivor").current_health
		instance2.get_node("Survivor").total_shotgun_ammo =  get_node("MaxsLevel").get_node("Survivor").total_shotgun_ammo
		instance2.get_node("Survivor").total_rifle_ammo =get_node("MaxsLevel").get_node("Survivor").total_rifle_ammo
		instance2.get_node("Survivor").total_pistol_ammo = get_node("MaxsLevel").get_node("Survivor").total_pistol_ammo
		instance2.get_node("Survivor").ammo_in_rifle = get_node("MaxsLevel").get_node("Survivor").ammo_in_rifle
		instance2.get_node("Survivor").ammo_in_pistol = get_node("MaxsLevel").get_node("Survivor").ammo_in_pistol
		instance2.get_node("Survivor").ammo_in_shotgun = get_node("MaxsLevel").get_node("Survivor").ammo_in_shotgun
		instance2.get_node("Survivor").medkit_count = get_node("MaxsLevel").get_node("Survivor").medkit_count
		instance2.get_node("Survivor").level = 2 
		health = get_node("MaxsLevel").get_node("Survivor").current_health
		
		totalshotgunammo = get_node("MaxsLevel").get_node("Survivor").total_shotgun_ammo
		totalrifleammo = get_node("MaxsLevel").get_node("Survivor").total_rifle_ammo
		totalpistolammo = get_node("MaxsLevel").get_node("Survivor").total_pistol_ammo
		ammoinrifle = get_node("MaxsLevel").get_node("Survivor").ammo_in_rifle
		ammoinpistol = get_node("MaxsLevel").get_node("Survivor").ammo_in_pistol
		ammoinshotgun = get_node("MaxsLevel").get_node("Survivor").ammo_in_shotgun
		medkitcount = get_node("MaxsLevel").get_node("Survivor").medkit_count
		
		
		
		
		
		current_level = "instance2"
		get_node("MaxsLevel").queue_free()
		level = null
		pass
	
	if level == 3:
		
		var scene3_to_instance = preload("res://Scenes/RensLevel.tscn")
		var instance3 = scene3_to_instance.instantiate()
		add_child(instance3)
		instance3.get_node("Survivor").current_health = get_node("level2").get_node("Survivor").current_health
		instance3.get_node("Survivor").total_shotgun_ammo =get_node("level2").get_node("Survivor").total_shotgun_ammo
		instance3.get_node("Survivor").total_rifle_ammo =get_node("level2").get_node("Survivor").total_rifle_ammo
		instance3.get_node("Survivor").total_pistol_ammo =get_node("level2").get_node("Survivor").total_pistol_ammo
		instance3.get_node("Survivor").ammo_in_rifle =get_node("level2").get_node("Survivor").ammo_in_rifle
		instance3.get_node("Survivor").ammo_in_pistol =get_node("level2").get_node("Survivor").ammo_in_pistol
		instance3.get_node("Survivor").ammo_in_shotgun =get_node("level2").get_node("Survivor").ammo_in_shotgun
		instance3.get_node("Survivor").medkit_count =get_node("level2").get_node("Survivor").medkit_count
		instance3.get_node("Survivor").level = 3
		current_level = "instance3"
		get_node("level2").queue_free()
		level = null
		
		totalshotgunammo = get_node("level2").get_node("Survivor").total_shotgun_ammo
		totalrifleammo = get_node("level2").get_node("Survivor").total_rifle_ammo
		totalpistolammo = get_node("level2").get_node("Survivor").total_pistol_ammo
		ammoinrifle = get_node("level2").get_node("Survivor").ammo_in_rifle
		ammoinpistol = get_node("level2").get_node("Survivor").ammo_in_pistol
		ammoinshotgun = get_node("level2").get_node("Survivor").ammo_in_shotgun
		medkitcount = get_node("level2").get_node("Survivor").medkit_count
	
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	var scene1_to_instance = preload("res://Scenes/MaxsLevel.tscn")
	var instance1 = scene1_to_instance.instantiate()
	find_child("MainMenu").visible = false
	add_child(instance1)
	print("play button pressed")
	current_level = "instance1"
	

func _on_load_button_pressed() -> void:
	pass




func _on_death() -> void:
	var death_screen = preload("res://Scenes/death_screen.tscn").instantiate()
	add_child(death_screen)
	
	
	
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if find_child("MainMenu"):
		find_child("MainMenu").visible = false
	else:
		print("Error: MainMenu node not found!")

	death_screen.connect("gui_input", Callable(self, "_on_death_screen_clicked"))

#func _on_death_screen_clicked(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		#_go_to_main_menu()


func _go_to_main_menu() -> void:
	for child in get_children():
		if child.name != "MainMenu":
			child.queue_free()
	
	if find_child("MainMenu"):
		find_child("MainMenu").visible = true
	else:
		print("Error: MainMenu node not found!")

	print("Returned to Main Menu.")

func respawn():
	print("HIIIi")
	print(get_children())
	print("")
	if pop == 1:
		var scene1_to_instance = preload("res://Scenes/MaxsLevel.tscn")
		var reinstance1 = scene1_to_instance.instantiate()
		add_child(reinstance1)
		reinstance1.get_node("Survivor").current_health = health
		reinstance1.get_node("Survivor").total_shotgun_ammo =  totalshotgunammo
		reinstance1.get_node("Survivor").total_rifle_ammo = totalrifleammo
		reinstance1.get_node("Survivor").total_pistol_ammo =totalpistolammo
		reinstance1.get_node("Survivor").ammo_in_rifle = ammoinrifle
		reinstance1.get_node("Survivor").ammo_in_pistol = ammoinpistol
		reinstance1.get_node("Survivor").ammo_in_shotgun = ammoinshotgun
		reinstance1.get_node("Survivor").medkit_count = medkitcount
		reinstance1.get_node("Survivor").level = 1
		print(get_children())
		get_node("DeathScreen").visible = false
		get_node("DeathScreen").queue_free()
		
		
	
	elif pop == 2:
		var scene2_to_instance = preload("res://Scenes/level2.tscn")
		var reinstance2 = scene2_to_instance.instantiate()
		add_child(reinstance2)
		reinstance2.get_node("Survivor").current_health = health
		reinstance2.get_node("Survivor").total_shotgun_ammo =  totalshotgunammo
		reinstance2.get_node("Survivor").total_rifle_ammo = totalrifleammo
		reinstance2.get_node("Survivor").total_pistol_ammo =totalpistolammo
		reinstance2.get_node("Survivor").ammo_in_rifle = ammoinrifle
		reinstance2.get_node("Survivor").ammo_in_pistol = ammoinpistol
		reinstance2.get_node("Survivor").ammo_in_shotgun = ammoinshotgun
		reinstance2.get_node("Survivor").medkit_count = medkitcount
		reinstance2.get_node("Survivor").level = 2
		print(get_children())
		get_node("DeathScreen").visible = false
		get_node("DeathScreen").queue_free()
		
		pass
	
	elif pop == 3:
		var scene3_to_instance = preload("res://Scenes/RensLevel.tscn")
		var reinstance3 = scene3_to_instance.instantiate()
		add_child(reinstance3)
		reinstance3.get_node("Survivor").current_health = health
		reinstance3.get_node("Survivor").total_shotgun_ammo =  totalshotgunammo
		reinstance3.get_node("Survivor").total_rifle_ammo = totalrifleammo
		reinstance3.get_node("Survivor").total_pistol_ammo =totalpistolammo
		reinstance3.get_node("Survivor").ammo_in_rifle = ammoinrifle
		reinstance3.get_node("Survivor").ammo_in_pistol = ammoinpistol
		reinstance3.get_node("Survivor").ammo_in_shotgun = ammoinshotgun
		reinstance3.get_node("Survivor").medkit_count = medkitcount
		reinstance3.get_node("Survivor").level = 3
		print(get_children())
		get_node("DeathScreen").visible = false
		get_node("DeathScreen").queue_free()
		pass
	
	
	
	
