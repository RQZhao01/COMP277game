extends CharacterBody2D

class_name Survivor

signal death
signal current_health_changed
signal weapon_changed(weapon:String)
signal medkit_change

var level = 1
# State variables to manage player's actionss
var reloading: bool = false  # Whether the player is reloading
var current_weapon: String = "rifle"  # Current weapon equipped
var player_speed  # Current speed of the players

var stamina = 150
var stamina_state

# Constants for gameplay mechanics
const RIFLE_FIRE_RATE: float = 5.0  # Rate of fire for the rifle
const SHOTGUN_FIRE_RATE: float = 1.0  # Rate of fire for the shotgun
const MOUSE_SENSITIVITY = -0.005  # Sensitivity of mouse for aiming

# Player movement speed settings
const WALK_SPEED: float = 250
const RUN_SPEED: float = 500
const SLOW_WALK_SPEED: float = 125

# Maximum ammo capacities for each weapon
const MAX_RIFLE_AMMO: int = 240
const MAX_SHOTGUN_AMMO: int = 60
const MAX_PISTOL_AMMO: int = 120

# Maximum medkits and player health points
const MAX_MEDKITS: int = 3
const PLAYER_HP: int = 100
var medkit_count: int = 0  # Number of medkits currently held
var is_alive: bool = true #is alive for player
var current_health: int = PLAYER_HP

# Magazine capacities for weapons
const RIFLE_MAGAZINE_CAPACITY: int = 30
const PISTOL_MAGAZINE_CAPACITY: int = 15
const SHOTGUN_TUBE_CAPACITY: int = 8

# Inventory variables to track ammo and medkits
var total_shotgun_ammo: int = 0
var total_rifle_ammo: int = 0
var total_pistol_ammo: int = 0

var ammo_in_rifle: int = 0
var ammo_in_pistol: int = 0
var ammo_in_shotgun: int = 0

# Miscellaneous variables
var mouse_position  # Tracks the mouse position
var previous_position  # Last recorded mouse position
var delay: float = 0.0  # Delay between actions like shooting

# Reload rifle logic
func reload_rifle():
	if total_rifle_ammo > 0 && ammo_in_rifle < RIFLE_MAGAZINE_CAPACITY:
		# Play reload animation and sound
		$AnimatedSprite2D.play("reload_rifle")
		var reload_rifle_sound_scene = load("res://Scenes/Sounds/rifle_reload_sound.tscn")
		var reload_rifle_sound = reload_rifle_sound_scene.instantiate()
		self.add_child(reload_rifle_sound)
		
		reloading = true
		var ammo_difference = RIFLE_MAGAZINE_CAPACITY - ammo_in_rifle
		# Add ammo to magazine while reducing total ammo
		if total_rifle_ammo >= ammo_difference:
			total_rifle_ammo -= ammo_difference
			ammo_in_rifle += ammo_difference
			print("Ammo in pocket: ", total_rifle_ammo)
		else:
			ammo_in_rifle += total_rifle_ammo
			total_rifle_ammo = 0
	else:
		print("Not enough ammo to reload or no need to reload")

# Reload pistol logic
func reload_pistol():
	if total_pistol_ammo > 0 && ammo_in_pistol < PISTOL_MAGAZINE_CAPACITY:
		# Play reload animation and sound
		$AnimatedSprite2D.play("reload_pistol")
		var reload_pistol_sound_scene = load("res://Scenes/Sounds/pistol_reload_sound.tscn")
		var reload_pistol_sound = reload_pistol_sound_scene.instantiate()
		self.add_child(reload_pistol_sound)
		
		reloading = true
		var ammo_difference = PISTOL_MAGAZINE_CAPACITY - ammo_in_pistol
		# Add ammo to magazine while reducing total ammo
		if total_pistol_ammo >= ammo_difference:
			total_pistol_ammo -= ammo_difference
			ammo_in_pistol += ammo_difference
			print("Ammo in pocket: ", total_pistol_ammo)
		else:
			ammo_in_pistol += total_pistol_ammo
			total_pistol_ammo = 0
	else:
		print("Not enough ammo to reload or no need to reload")

# Reload shotgun logic
func reload_shotgun():
	if total_shotgun_ammo > 0 && ammo_in_shotgun < SHOTGUN_TUBE_CAPACITY:
		# Play reload animation
		$AnimatedSprite2D.play("reload_shotgun")
		var reload_shotgun_sound_scene = load("res://Scenes/Sounds/shotgun_reload_sound.tscn")
		var reload_shotgun_sound = reload_shotgun_sound_scene.instantiate()
		self.add_child(reload_shotgun_sound)
		reloading = true
		var ammo_difference = SHOTGUN_TUBE_CAPACITY - ammo_in_shotgun
		# Add ammo to tube while reducing total ammo
		if total_shotgun_ammo >= ammo_difference:
			total_shotgun_ammo -= ammo_difference
			ammo_in_shotgun += ammo_difference
			print("Ammo in pocket: ", total_shotgun_ammo)
		else:
			ammo_in_shotgun += total_shotgun_ammo
			total_shotgun_ammo = 0
	else:
		print("Not enough ammo to reload or no need to reload")

# Add a medkit to the inventory
func add_medkit():
	if medkit_count < MAX_MEDKITS:
		medkit_count += 1
		print("Picked up 1 medkit")
		emit_signal("medkit_change")
		
		
# Use a medkit
func use_medkit():
		if medkit_count > 0 && is_alive && current_health < PLAYER_HP:
			medkit_count -= 1
			current_health = PLAYER_HP
			print("Used 1 medkit. Current health:", current_health)
			emit_signal("medkit_change")
		# Play healing sound!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else:
			print("No medkits left or player is dead")
			

func die():
	is_alive = false
	get_parent().get_parent().pop = level
	get_parent().get_node("Zombies").queue_free()
	#queue_free()
	get_parent().queue_free()
	get_parent().get_parent().death.emit()
	

# Add ammo based on the current weapon
func add_ammo():
	match current_weapon:
		"rifle":
			if total_rifle_ammo < MAX_RIFLE_AMMO:
				total_rifle_ammo += RIFLE_MAGAZINE_CAPACITY
				total_rifle_ammo = min(total_rifle_ammo, MAX_RIFLE_AMMO)
				print("Picked up rifle ammo")
		"pistol":
			if total_pistol_ammo < MAX_PISTOL_AMMO:
				total_pistol_ammo += PISTOL_MAGAZINE_CAPACITY
				total_pistol_ammo = min(total_pistol_ammo, MAX_PISTOL_AMMO)
				print("Picked up pistol ammo")
		"shotgun":
			if total_shotgun_ammo < MAX_SHOTGUN_AMMO:
				total_shotgun_ammo += SHOTGUN_TUBE_CAPACITY
				total_shotgun_ammo = min(total_shotgun_ammo, MAX_SHOTGUN_AMMO)
				print("Picked up shotgun ammo")

# Shooting logic for the player
func update_player_shooting():
	if !reloading:  # Only shoot if not reloading
		delay += 1
		match current_weapon:
			# Rifle shooting logic
			"rifle":
				if Input.is_action_pressed("shoot") and delay > RIFLE_FIRE_RATE:
					if ammo_in_rifle > 0:
						ammo_in_rifle -= 1
						shoot_rifle()
						$Noisecircle.scale= Vector2(80,80)
						delay = 0.0
					else:
						stop_shooting()
						print("Out of ammo in rifle")
				else:
					stop_shooting()

			# Pistol shooting logic
			"pistol":
				if Input.is_action_just_pressed("shoot"):
					if ammo_in_pistol > 0:
						ammo_in_pistol -= 1
						shoot_pistol()
						$Noisecircle.scale= Vector2(55,55)
						delay = 0.0
					else:
						stop_shooting()
						print("Out of ammo in pistol")
				else:
					stop_shooting()

			# Shotgun shooting logic
			"shotgun":
				if Input.is_action_just_pressed("shoot") and delay > SHOTGUN_FIRE_RATE:
					if ammo_in_shotgun > 0:
						ammo_in_shotgun -= 1
						shoot_shotgun()
						$Noisecircle.scale= Vector2(110,110)
						delay = 0.0
					else:
						stop_shooting()
						print("Out of ammo in shotgun")
				else:
					stop_shooting()

# Stops the shooting animation and muzzle flash
func stop_shooting():
	$MuzzleFlash/AnimatedSprite2D.stop()
	$MuzzleFlash/AnimatedSprite2D.visible = false
	$PistolMuzzleFlash/AnimatedSprite2D.stop()
	$PistolMuzzleFlash/AnimatedSprite2D.visible = false
	
	
# Function to handle shooting the rifle
func shoot_rifle():
	# Print ammo count for debugging and visibility
	print("Ammo left in rifle:", ammo_in_rifle)
	
	# Enable and play the muzzle flash effect
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
	
	var muzzle_flash_light = load("res://Scenes/MaxsLevel/muzzle_flash_light.tscn")
	var muzzle_flash_light_scene = muzzle_flash_light.instantiate()
	self.add_child(muzzle_flash_light_scene)
	
	# Load and play the rifle shooting sound
	var rifle_sound_scene = load("res://Scenes/Sounds/rifle_shoot_sound.tscn")
	var rifle_sound = rifle_sound_scene.instantiate()
	add_child(rifle_sound)
	
	# Determine the direction the player is facing
	var facing_direction = Vector2.UP.rotated(rotation + PI / 2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	
	# Introduce randomness to simulate bullet spread
	var random_number = randf_range(-PI / 10, PI / 10)
	projectile.position = self.position + Vector2(20, -70).rotated(rotation + PI / 2)
	projectile.rotation = rotation + PI / 2
	
	# Adjust bullet spread based on player speed
	if self.player_speed > 250:  # Player is sprinting
		projectile.direction_shot = facing_direction.rotated(1.5 * random_number)
		projectile.rotate(1.5 * random_number)
	elif self.player_speed < 250:  # Player is walking slowly
		projectile.direction_shot = facing_direction.rotated(0.15 * random_number)
		projectile.rotate(0.15 * random_number)
	else:  # Normal walking speed
		projectile.direction_shot = facing_direction.rotated(0.2 * random_number)
		projectile.rotate(0.2 * random_number)
	
	# Add the bullet to the game
	get_parent().add_child(projectile)

# Function to handle shooting the pistol (similar to rifle logic)
func shoot_pistol():
	print("Ammo left in pistol:", ammo_in_pistol)
	$PistolMuzzleFlash/AnimatedSprite2D.visible = true
	$PistolMuzzleFlash/AnimatedSprite2D.play()
	
	var muzzle_flash_light = load("res://Scenes/MaxsLevel/muzzle_flash_light.tscn")
	var muzzle_flash_light_scene = muzzle_flash_light.instantiate()
	self.add_child(muzzle_flash_light_scene)
	
	var pistol_shoot_sound_scene = load("res://Scenes/Sounds/pistol_shoot_sound.tscn")
	var pistol_shoot_sound = pistol_shoot_sound_scene.instantiate()
	add_child(pistol_shoot_sound)
	
	var facing_direction = Vector2.UP.rotated(rotation + PI / 2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	var random_number = randf_range(-PI / 10, PI / 10)
	projectile.position = self.position + Vector2(20, -70).rotated(rotation + PI / 2)
	projectile.rotation = rotation + PI / 2
	
	if self.player_speed > 250:
		projectile.direction_shot = facing_direction.rotated(0.1 * random_number)
		projectile.rotate(0.1 * random_number)
	elif self.player_speed < 250:
		projectile.direction_shot = facing_direction.rotated(0.1 * random_number)
		projectile.rotate(0.1 * random_number)
	else:
		projectile.direction_shot = facing_direction.rotated(0.1 * random_number)
		projectile.rotate(0.1 * random_number)
	
	get_parent().add_child(projectile)

# Function to handle shooting the shotgun (similar to rifle and pistol logic)
func shoot_shotgun():
	var projectiles_array: Array
	# print ammo count
	print("Ammo left in shotgun:", ammo_in_shotgun)
	# play muzzle flash animation
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
	
	var muzzle_flash_light = load("res://Scenes/MaxsLevel/muzzle_flash_light.tscn")
	var muzzle_flash_light_scene = muzzle_flash_light.instantiate()
	self.add_child(muzzle_flash_light_scene)
	
	# this plays the sound for the shotgun
	var shotgun_shoot_sound_scene = load("res://Scenes/Sounds/shotgun_shoot_sound.tscn")
	var shotgun_shoot_sound = shotgun_shoot_sound_scene.instantiate()
	add_child(shotgun_shoot_sound)
	
	var facing_direction = Vector2.UP.rotated(rotation + PI / 2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	for i in range(8):
		var projectile = bullet.instantiate()
		var random_number = randf_range(-PI / 5, PI / 5)
		projectile.position = self.position + Vector2(20, -70).rotated(rotation + PI / 2)
		projectile.rotation = rotation + PI / 2
	
		if self.player_speed > 250:
			projectile.direction_shot = facing_direction.rotated(1.5 * random_number)
			projectile.rotate(1.5 * random_number)
		elif self.player_speed < 250:
			projectile.direction_shot = facing_direction.rotated(0.15 * random_number)
			projectile.rotate(0.15 * random_number)
		else:
			projectile.direction_shot = facing_direction.rotated(0.2 * random_number)
			projectile.rotate(0.2 * random_number)
			
		projectiles_array.append(projectile)
	
	for element in projectiles_array:
		get_parent().add_child(element)

# Function to update player movement based on inputs and actions
func update_player_movement():
	if reloading:
		player_speed = 50  # Reduce speed when reloading
	else:
		# Adjust speed and animations based on movement inputs
		#ctrl makes the player slow walk
		if Input.is_action_pressed("ui_ctrl"):
			stamina_state = "regenerating"
			player_speed = SLOW_WALK_SPEED
			$Noisecircle.scale= Vector2(20,20)
			match current_weapon:
				"rifle":
					$AnimatedSprite2D.play("rifle_slow_walk")
				"pistol":
					$AnimatedSprite2D.play("pistol_slow_walk")
				"shotgun":
					$AnimatedSprite2D.play("shotgun_slow_walk")
		#shift makes the player run
		elif Input.is_action_pressed("ui_shift"):
			stamina_state = "losing"
			if stamina > 0:
				player_speed = RUN_SPEED
				$Noisecircle.scale= Vector2(100,100)
				match current_weapon:
					"rifle":
						$AnimatedSprite2D.play("rifle_run")
					"pistol":
						$AnimatedSprite2D.play("pistol_run")
					"shotgun":
						$AnimatedSprite2D.play("shotgun_run")
			else:
				player_speed = WALK_SPEED
				match current_weapon:
					"rifle":
						$AnimatedSprite2D.play("rifle_walk")
					"pistol":
						$AnimatedSprite2D.play("pistol_walk")
					"shotgun":
						$AnimatedSprite2D.play("shotgun_walk")
			
		#the default movement is walk
		else:
			stamina_state = "regenerating"
			player_speed = WALK_SPEED
			$Noisecircle.scale= Vector2(50,50)
			match current_weapon:
				"rifle":
					$AnimatedSprite2D.play("rifle_walk")
				"pistol":
					$AnimatedSprite2D.play("pistol_walk")
				"shotgun":
					$AnimatedSprite2D.play("shotgun_walk")
		
		# Idle animations when not moving
		if velocity == Vector2(0, 0) && !reloading:
			match current_weapon:
				"rifle":
					$AnimatedSprite2D.play("rifle_idle")
				"pistol":
					$AnimatedSprite2D.play("pistol_idle")
				"shotgun":
					$AnimatedSprite2D.play("shotgun_idle")
	
	# Compute movement vector and apply sliding motion
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
	var vector = player_speed * input_direction
	velocity = vector.rotated(self.rotation + PI / 2)
	if velocity == Vector2(0,0):
		$Noisecircle.scale= Vector2(20,20)
	move_and_slide()

# Function to handle reloading logic
func update_reloading():
	if Input.is_action_just_pressed("reload") && !reloading:
		# Check the current weapon and call the respective reload function
		match current_weapon:
			"rifle":
				reload_rifle()
			"pistol":
				reload_pistol()
			"shotgun":
				reload_shotgun()

# Function to update the player's direction based on mouse movement
func update_player_direction():
	# Get the mouse position relative to the player
	mouse_position = get_local_mouse_position()
	
	# Update the player's rotation angle based on mouse movement
	if InputEventMouseMotion:

		#print(mouse_position)
		#print(" ")
		#print(mouse_position_global)
		#print(" ")
		#print(DisplayServer.mouse_get_position())
		#print("")
		#print("")
		#print("")
		#print("////////////////////////////")
		print(DisplayServer.mouse_get_position())
		if mouse_position.y >= 2397 or mouse_position.y <= -2397:
			if mouse_position.y >= 0:
				Input.warp_mouse(Vector2(get_viewport().size.x/2 - 50,DisplayServer.mouse_get_position().y))
			else:
				Input.warp_mouse(Vector2(get_viewport().size.x/2 + 50,DisplayServer.mouse_get_position().y))
		
		if mouse_position.y >= 2397 or mouse_position.y <= -2397:
			if mouse_position.y >= 0:
				Input.warp_mouse(Vector2(get_viewport().size.x/2 - 50 ,DisplayServer.mouse_get_position().y))
			else:
				Input.warp_mouse(Vector2(get_viewport().size.x/2 + 50,DisplayServer.mouse_get_position().y))
		var angle = (previous_position.y - mouse_position.y) * MOUSE_SENSITIVITY
		self.rotation = angle
		

# Function to handle physics-based updates 
# physics process is called with a set frequency, eg: every 0.01 seconds
# use for stuff when timing matters
func _physics_process(_delta: float) -> void:
	
	if stamina_state == "regenerating":
		stamina += 1
		clamp(stamina, 0, 150)
	elif stamina_state == "losing":
		stamina -= 1
		clamp(stamina, 0, 150)
		
		
	# Update player direction, reloading, movement, and shooting
	update_player_direction()
	update_reloading()
	update_player_movement()
	update_player_shooting()

# Function to handle general updates every frame
# process is called every frame, which is uneven and changes between computers
func _process(_delta: float) -> void:
	emit_signal("medkit_change")
	#print(current_health)
	current_health_changed.emit()
	emit_signal("weapon_changed",current_weapon)
	

	# Change the current weapon based on input
	if Input.is_action_pressed("weapon_1"):
		current_weapon = "pistol"
		emit_signal("weapon_changed",current_weapon)
	elif Input.is_action_pressed("weapon_2"):
		current_weapon = "rifle"
		emit_signal("weapon_changed",current_weapon)
	elif Input.is_action_pressed("weapon_3"):
		current_weapon = "shotgun"
		emit_signal("weapon_changed",current_weapon)
		
	if Input.is_action_just_pressed("use_medkit"):
		use_medkit()
		
	if current_health <= 0 && is_alive:
		die()

# Function called when the node is ready
func _ready() -> void:
	stamina_state = "regenerating"
	# Initialize variables and set default values
	previous_position = Vector2(0, -1)
	$AnimatedSprite2D.play("rifle_idle")  # Set the initial animation to rifle idle
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN  # Hide the mouse cursor
	$MuzzleFlash/AnimatedSprite2D.visible = false  # Hide the muzzle flash initially
	$PistolMuzzleFlash/AnimatedSprite2D.visible = false  # Hide the muzzle flash initially
	current_weapon = "rifle"  # Default to rifle as the starting weapon

# Function triggered when the animation finishes
func _on_animated_sprite_2d_animation_finished() -> void:
	reloading = false  # Reset reloading state
	print("animation finished")  # Debug print to confirm animation completion


func _on_darkrooms_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_exit_3_game_won() -> void:
	pass # Replace with function body.
