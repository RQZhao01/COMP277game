extends CharacterBody2D

class_name Survivor

<<<<<<< Updated upstream
var mouse_position
var previous_position
var x
var medkit_count: int = 0
=======
signal current_health_changed
signal weapon_changed(weapon:String)
signal ammo_updated(weapon_type: String)
# State variables to manage player's actions
var shooting: bool = false  # Whether the player is shooting
var reloading: bool = false  # Whether the player is reloading
var current_weapon: String = "rifle"  # Current weapon equipped
var player_speed  # Current speed of the player

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
>>>>>>> Stashed changes
const MAX_MEDKITS: int = 3
var ammo_count: int = 0
const MAX_AMMO: int = 120
var mag_count: int = 0
const MAX_MAG: int = 30
var delay: int = 0

var player_speed

var shooting = false
var reloading = false

@export var mouse_sensitivity = -0.005
@export var walk_speed: float = 250
@export var run_speed: float = 500
@export var slow_walk_speed: float = 125

func update_player_direction():
	mouse_position = (get_local_mouse_position())
	if InputEventMouseMotion:
		var angle = (previous_position.y - mouse_position.y) * mouse_sensitivity
		self.rotation = angle
		
<<<<<<< Updated upstream
	
func update_player_movement():
	if reloading:
		player_speed = 50
=======
		reloading = true
		var ammo_difference = RIFLE_MAGAZINE_CAPACITY - ammo_in_rifle
		# Add ammo to magazine while reducing total ammo
		if total_rifle_ammo >= ammo_difference:
			total_rifle_ammo -= ammo_difference
			ammo_in_rifle += ammo_difference
			print("Ammo in pocket: ", total_rifle_ammo)
			update_ammo("rifle", ammo_in_rifle, total_rifle_ammo)
		else:
			ammo_in_rifle += total_rifle_ammo
			total_rifle_ammo = 0
>>>>>>> Stashed changes
	else:
		if Input.is_action_pressed("ui_ctrl"):
			player_speed = slow_walk_speed
			$AnimatedSprite2D.play("rifle_slow_walk")
		elif Input.is_action_pressed("ui_shift"):
			player_speed = run_speed
			$AnimatedSprite2D.play("rifle_run")
		else:
			player_speed = walk_speed
			$AnimatedSprite2D.play("rifle_walk")
			
		if velocity == Vector2(0,0) && !reloading:
			$AnimatedSprite2D.play("rifle_idle")
			
		
	var input_direction = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	)
	var vector = player_speed * input_direction
	velocity = vector.rotated(self.rotation +PI/2)
	move_and_slide()
	
func update_player_shooting():
	if !reloading:
		delay +=1
		if Input.is_action_pressed("shoot") and delay > 5:
			shoot()
			delay = 0
		elif Input.is_action_just_released("shoot"):
			stop_shooting()
	
	
func reload():
	if mag_count < MAX_MAG and ammo_count > 0:
		reloading = true
<<<<<<< Updated upstream
		$AnimatedSprite2D.animation = "rifle_reload"
		$MuzzleFlash/AnimatedSprite2D.visible = false
		# calculate the ammo for reload
		var needed_ammo = MAX_MAG - mag_count
		var ammo_to_reload = min(needed_ammo, ammo_count)
		ammo_count -= ammo_to_reload
		mag_count += ammo_to_reload
		print("Reloaded. Mag: ", mag_count, " Remaining ammo: ", ammo_count)
	elif ammo_count < MAX_MAG:
		print("Not enough ammo to reload!")

		
func update_reloading():
	if Input.is_action_just_pressed("reload") && !reloading:
		reload()
		print("reload activated")
		
=======
		var ammo_difference = PISTOL_MAGAZINE_CAPACITY - ammo_in_pistol
		# Add ammo to magazine while reducing total ammo
		if total_pistol_ammo >= ammo_difference:
			total_pistol_ammo -= ammo_difference
			ammo_in_pistol += ammo_difference
			print("Ammo in pocket: ", total_pistol_ammo)
			update_ammo("pistol", ammo_in_pistol, total_pistol_ammo)
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
		reloading = true
		var ammo_difference = SHOTGUN_TUBE_CAPACITY - ammo_in_shotgun
		# Add ammo to tube while reducing total ammo
		if total_shotgun_ammo >= ammo_difference:
			total_shotgun_ammo -= ammo_difference
			ammo_in_shotgun += ammo_difference
			print("Ammo in pocket: ", total_shotgun_ammo)
			update_ammo("shotgun", ammo_in_shotgun, total_shotgun_ammo)
		else:
			ammo_in_shotgun += total_shotgun_ammo
			total_shotgun_ammo = 0
	else:
		print("Not enough ammo to reload or no need to reload")
		
		
func update_ammo(weapon_type: String, ammo_in_gun: int, total_ammo: int):
	print("called")
	match weapon_type:
		"rifle":
			ammo_in_rifle = ammo_in_gun
			total_rifle_ammo = total_ammo
		"pistol":
			ammo_in_pistol = ammo_in_gun
			total_pistol_ammo = total_ammo
		"shotgun":
			ammo_in_shotgun = ammo_in_gun
			total_shotgun_ammo = total_ammo
	
	emit_signal("ammo_updated", weapon_type)
	print("1")
>>>>>>> Stashed changes

	
func add_medkit():
	if medkit_count < MAX_MEDKITS:
		medkit_count +=1
		print("get 1 medkit!!!!!!")
	else:
		pass
	
func use_medkit():
	if medkit_count > 0:
		medkit_count -=1
		print("1 medkit used")
	else:
		print("no medkit left")
		
	
func add_ammo():
<<<<<<< Updated upstream
	if ammo_count < MAX_AMMO:
		ammo_count += 30
		ammo_count = min(ammo_count, MAX_AMMO)
		print("Picked up 30 ammo, current ammo count:", ammo_count)
	else:
		pass


func _ready() -> void:
	previous_position = Vector2(0,-1) 
	$AnimatedSprite2D.play("rifle_idle")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func shoot():
	if mag_count > 0:
		mag_count -= 1
		print("Shots left in mag:", mag_count, " Total ammo remaining:", ammo_count)
		$MuzzleFlash/AnimatedSprite2D.visible = true
		$MuzzleFlash/AnimatedSprite2D.play()
		
		var scene = load("res://Scenes/GunShootSound.tscn")
		var sound = scene.instantiate()
		add_child(sound)
		rifle_shoot()
	else:
		$MuzzleFlash/AnimatedSprite2D.visible = false
		print("Out of ammo in mag, need to reload")

func _on_animated_sprite_2d_animation_finished() -> void:
	reloading = false
	print("animation finsihed")
	
=======
	match current_weapon:
		"rifle":
			if total_rifle_ammo < MAX_RIFLE_AMMO:
				total_rifle_ammo += RIFLE_MAGAZINE_CAPACITY
				total_rifle_ammo = min(total_rifle_ammo, MAX_RIFLE_AMMO)
				print("Picked up rifle ammo, ammo in pocket: ", total_rifle_ammo)
				update_ammo("rifle", ammo_in_rifle, total_rifle_ammo)
		"pistol":
			if total_pistol_ammo < MAX_PISTOL_AMMO:
				total_pistol_ammo += PISTOL_MAGAZINE_CAPACITY
				total_pistol_ammo = min(total_pistol_ammo, MAX_PISTOL_AMMO)
				print("Picked up pistol ammo, ammo in pocket: ", total_pistol_ammo)
				update_ammo("pistol", ammo_in_pistol, total_pistol_ammo)
		"shotgun":
			if total_shotgun_ammo < MAX_SHOTGUN_AMMO:
				total_shotgun_ammo += SHOTGUN_TUBE_CAPACITY
				total_shotgun_ammo = min(total_shotgun_ammo, MAX_SHOTGUN_AMMO)
				print("Picked up shotgun ammo, ammo in pocket: ", total_shotgun_ammo)
				update_ammo("shotgun", ammo_in_shotgun, total_shotgun_ammo)
				

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
						update_ammo("rifle", ammo_in_rifle, total_rifle_ammo)
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
						update_ammo("pistol", ammo_in_pistol, total_pistol_ammo)
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
						update_ammo("shotgun", ammo_in_shotgun, total_shotgun_ammo)
				else:
					stop_shooting()

# Stops the shooting animation and muzzle flash
>>>>>>> Stashed changes
func stop_shooting():
	$MuzzleFlash/AnimatedSprite2D.stop()
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func _process(_delta: float) -> void:
	pass
	
func rifle_shoot():
	var facing_direction = Vector2.UP.rotated(rotation + PI/2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	var random_number = randf_range(-PI/10, PI/10)
	projectile.position = self.position + Vector2(20,-70).rotated(rotation + PI/2)
	projectile.rotation = rotation + PI/2
	print(facing_direction)
	if self.player_speed > 250:
		
		projectile.direction_shot = facing_direction.rotated(1.5*random_number)
		projectile.rotate(1.5*random_number)
		get_parent().add_child(projectile)
	
	elif self.player_speed < 250:
		
		projectile.direction_shot = facing_direction.rotated(0.15*random_number)
		projectile.rotate(0.15*random_number)
		get_parent().add_child(projectile)
	
	else:
		print(random_number)
		projectile.direction_shot = facing_direction.rotated(0.2*random_number)
		print(facing_direction)
		projectile.rotate(0.2*random_number)
		get_parent().add_child(projectile)
		

func _physics_process(delta: float) -> void:
	update_player_direction()
	update_reloading()
	update_player_movement()
	update_player_shooting()
	
<<<<<<< Updated upstream
=======
	#print(current_health)
	current_health_changed.emit()
	emit_signal("weapon_changed",current_weapon)

	# Change the current weapon based on input
	if Input.is_action_pressed("weapon_1"):
		if current_weapon != "pistol":
			current_weapon = "pistol"
			emit_signal("weapon_changed",current_weapon)
			emit_signal("ammo_updated", "pistol")
			print("emitted!")
	elif Input.is_action_pressed("weapon_2"):
		if current_weapon != "rifle": 
			current_weapon = "rifle"
			emit_signal("weapon_changed",current_weapon)
			emit_signal("ammo_updated", "rifle")
	elif Input.is_action_pressed("weapon_3"):
		if current_weapon != "shotgun":
			current_weapon = "shotgun"
			emit_signal("weapon_changed",current_weapon)
			emit_signal("ammo_updated", "shotgun")
		
		
	if Input.is_action_just_pressed("use_medkit"):
		use_medkit()
		
	if current_health <= 0 && is_alive:
		die()

# Function called when the node is ready
func _ready() -> void:
	# Initialize variables and set default values
	previous_position = Vector2(0, -1)
	$AnimatedSprite2D.play("rifle_idle")  # Set the initial animation to rifle idle
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN  # Hide the mouse cursor
	$MuzzleFlash/AnimatedSprite2D.visible = false  # Hide the muzzle flash initially
	current_weapon = "rifle"  # Default to rifle as the starting weapon

# Function triggered when the animation finishes
func _on_animated_sprite_2d_animation_finished() -> void:
	reloading = false  # Reset reloading state
	print("animation finished")  # Debug print to confirm animation completion


func _on_darkrooms_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
>>>>>>> Stashed changes
