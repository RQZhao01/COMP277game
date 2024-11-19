extends CharacterBody2D

class_name Survivor

#States
var shooting: bool = false
var reloading: bool = false
var current_weapon: String = "rifle"
var player_speed

#Consts
const RIFLE_FIRE_RATE: float = 5.0
const SHOTGUN_FIRE_RATE: float = 1.0
const MOUSE_SENSITIVITY = -0.005

const WALK_SPEED: float = 250
const RUN_SPEED: float = 500
const SLOW_WALK_SPEED: float = 125

const MAX_RIFLE_AMMO: int = 240
const MAX_SHOTGUN_AMMO: int = 60
const MAX_PISTOL_AMMO: int = 120

const MAX_MEDKITS: int = 3
const RIFLE_MAGAZINE_CAPACITY: int = 30
const PISTOL_MAGAZINE_CAPACITY: int = 15
const SHOTGUN_TUBE_CAPACITY: int = 8

#Inventory
var total_shotgun_ammo: int = 0
var total_rifle_ammo: int = 0
var total_pistol_ammo: int = 0

var ammo_in_rifle: int = 0
var ammo_in_pistol: int = 0
var ammo_in_shotgun: int = 0

var medkit_count: int = 0

#Other
var mouse_position
var previous_position
var delay: float = 0.0


func reload_rifle():
	if total_rifle_ammo > 0 && ammo_in_rifle < 30:
		$AnimatedSprite2D.play("reload_rifle")
		
		var reload_rifle_sound_scene = load("res://Scenes/Sounds/rifle_reload_sound.tscn")
		var reload_rifle_sound = reload_rifle_sound_scene.instantiate()
		self.add_child(reload_rifle_sound)
		
		reloading = true
		var ammo_difference = RIFLE_MAGAZINE_CAPACITY - ammo_in_rifle
		if total_rifle_ammo >= ammo_difference:
			total_rifle_ammo -= ammo_difference
			ammo_in_rifle += ammo_difference
		else:
			ammo_in_rifle += total_rifle_ammo
			total_rifle_ammo -= total_rifle_ammo
	else:
		print("Not enough ammo to reload or no need to reload")
	
func reload_pistol():
	if total_pistol_ammo > 0 && ammo_in_pistol < 15:
		$AnimatedSprite2D.play("reload_pistol")
		var reload_pistol_sound_scene = load("res://Scenes/Sounds/pistol_reload_sound.tscn")
		var reload_pistol_sound = reload_pistol_sound_scene.instantiate()
		self.add_child(reload_pistol_sound)
		reloading = true
		var ammo_difference = PISTOL_MAGAZINE_CAPACITY - ammo_in_pistol
		if total_pistol_ammo >= ammo_difference:
			total_pistol_ammo -= ammo_difference
			ammo_in_pistol += ammo_difference
		else:
			ammo_in_pistol += total_pistol_ammo
			total_pistol_ammo -= total_pistol_ammo
	else:
		print("Not enough ammo to reload or no need to reload")
	
func reload_shotgun():
	if total_shotgun_ammo > 0 && ammo_in_shotgun < 8:
		$AnimatedSprite2D.play("reload_shotgun")
		reloading = true
		var ammo_difference = SHOTGUN_TUBE_CAPACITY - ammo_in_shotgun
		if total_shotgun_ammo >= ammo_difference:
			total_shotgun_ammo -= ammo_difference
			ammo_in_shotgun += ammo_difference
		else:
			ammo_in_shotgun += total_shotgun_ammo
			total_shotgun_ammo -= total_shotgun_ammo
	else:
		print("Not enough ammo to reload or no need to reload")
	
func add_medkit():
	if medkit_count < MAX_MEDKITS:
		medkit_count +=1
		print("get 1 medkit!!!!!!")
	
func use_medkit():
	if medkit_count > 0:
		medkit_count -=1
		print("1 medkit used")
	else:
		print("no medkit left")
		
func add_ammo():
	match current_weapon:
		"rifle":
			if total_rifle_ammo < MAX_RIFLE_AMMO:
				total_rifle_ammo += RIFLE_MAGAZINE_CAPACITY
				total_rifle_ammo = min(total_rifle_ammo, MAX_RIFLE_AMMO)
				print("Picked up 30 rifle ammo, total rifle ammo:", total_rifle_ammo)
		"pistol":
			if total_pistol_ammo < MAX_PISTOL_AMMO:
				total_pistol_ammo += PISTOL_MAGAZINE_CAPACITY
				total_pistol_ammo = min(total_pistol_ammo, MAX_PISTOL_AMMO)
				print("Picked up 15 pistol ammo, total pistol ammo:", total_pistol_ammo)
		"shotgun":
			if total_shotgun_ammo < MAX_SHOTGUN_AMMO:
				total_shotgun_ammo += SHOTGUN_TUBE_CAPACITY
				total_shotgun_ammo = min(total_shotgun_ammo, MAX_SHOTGUN_AMMO)
				print("Picked up 8 shotgun ammo, total shotgun ammo:", total_shotgun_ammo)

func update_player_shooting():
	if !reloading:
		delay += 1
		match current_weapon:
			"rifle":
				if Input.is_action_pressed("shoot") and delay > RIFLE_FIRE_RATE:
					if ammo_in_rifle > 0:
						ammo_in_rifle -= 1
						shoot_rifle()
						delay = 0.0
					else:
						$MuzzleFlash/AnimatedSprite2D.visible = false
						print("Out of ammo in rifle, need to reload")
				else:
					stop_shooting()
			"pistol":
				if Input.is_action_just_pressed("shoot"):
					if ammo_in_pistol > 0:
						ammo_in_pistol -= 1
						shoot_pistol()
						delay = 0.0
					else:
						$MuzzleFlash/AnimatedSprite2D.visible = false
						print("Out of ammo in pistol, need to reload")
				else:
					stop_shooting()
			"shotgun":
				if Input.is_action_just_pressed("shoot") and delay > SHOTGUN_FIRE_RATE:
					if ammo_in_shotgun > 0:
						ammo_in_shotgun -= 1
						shoot_shotgun()
						delay = 0.0
					else:
						$MuzzleFlash/AnimatedSprite2D.visible = false
						print("Out of ammo in shotgun, need to reload")
				else:
					stop_shooting()
		
func stop_shooting():
	$MuzzleFlash/AnimatedSprite2D.stop()
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func shoot_rifle():
	print("Ammo left in rifle:", ammo_in_rifle, " Total rifle ammo remaining:", total_rifle_ammo)
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
		
	var rifle_sound_scene = load("res://Scenes/Sounds/rifle_shoot_sound.tscn")
	var rifle_sound = rifle_sound_scene.instantiate()
	add_child(rifle_sound)
	
	var facing_direction = Vector2.UP.rotated(rotation + PI/2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	var random_number = randf_range(-PI/10, PI/10)
	projectile.position = self.position + Vector2(20,-70).rotated(rotation + PI/2)
	projectile.rotation = rotation + PI/2
	
	if self.player_speed > 250:
		projectile.direction_shot = facing_direction.rotated(1.5*random_number)
		projectile.rotate(1.5*random_number)
		get_parent().add_child(projectile)
	elif self.player_speed < 250:
		projectile.direction_shot = facing_direction.rotated(0.15*random_number)
		projectile.rotate(0.15*random_number)
		get_parent().add_child(projectile)
	else:
		projectile.direction_shot = facing_direction.rotated(0.2*random_number)
		projectile.rotate(0.2*random_number)
		get_parent().add_child(projectile)
		
func shoot_pistol():
	print("Ammo left in pistol:", ammo_in_pistol, " Total pistol ammo remaining:", total_pistol_ammo)
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
		
	var pistol_shoot_sound_scene = load("res://Scenes/Sounds/pistol_shoot_sound.tscn")
	var pistol_shoot_sound = pistol_shoot_sound_scene.instantiate()
	add_child(pistol_shoot_sound)
	
	var facing_direction = Vector2.UP.rotated(rotation + PI/2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	var random_number = randf_range(-PI/10, PI/10)
	projectile.position = self.position + Vector2(20,-70).rotated(rotation + PI/2)
	projectile.rotation = rotation + PI/2
	
	if self.player_speed > 250:
		projectile.direction_shot = facing_direction.rotated(1.5*random_number)
		projectile.rotate(1.5*random_number)
		get_parent().add_child(projectile)
	elif self.player_speed < 250:
		projectile.direction_shot = facing_direction.rotated(0.15*random_number)
		projectile.rotate(0.15*random_number)
		get_parent().add_child(projectile)
	else:
		projectile.direction_shot = facing_direction.rotated(0.2*random_number)
		projectile.rotate(0.2*random_number)
		get_parent().add_child(projectile)
	
func shoot_shotgun():
	print("Ammo left in shotgun:", ammo_in_shotgun, " Total shotgun ammo remaining:", total_shotgun_ammo)
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
		
	var shotgun_shoot_sound_scene = load("res://Scenes/Sounds/shotgun_shoot_sound.tscn")
	var shotgun_shoot_sound = shotgun_shoot_sound_scene.instantiate()
	add_child(shotgun_shoot_sound)
	
	var facing_direction = Vector2.UP.rotated(rotation + PI/2)
	var bullet = preload("res://Scenes/Bullet.tscn")
	var projectile = bullet.instantiate()
	var random_number = randf_range(-PI/10, PI/10)
	projectile.position = self.position + Vector2(20,-70).rotated(rotation + PI/2)
	projectile.rotation = rotation + PI/2
	
	if self.player_speed > 250:
		projectile.direction_shot = facing_direction.rotated(1.5*random_number)
		projectile.rotate(1.5*random_number)
		get_parent().add_child(projectile)
	elif self.player_speed < 250:
		projectile.direction_shot = facing_direction.rotated(0.15*random_number)
		projectile.rotate(0.15*random_number)
		get_parent().add_child(projectile)
	else:
		projectile.direction_shot = facing_direction.rotated(0.2*random_number)
		projectile.rotate(0.2*random_number)
		get_parent().add_child(projectile)
			
func update_player_movement():
	if reloading:
		player_speed = 50
	else:
		if Input.is_action_pressed("ui_ctrl"):
			player_speed = SLOW_WALK_SPEED
			match current_weapon:
				"rifle":
					$AnimatedSprite2D.play("rifle_slow_walk")
				"pistol":
					$AnimatedSprite2D.play("pistol_slow_walk")
				"shotgun":
					$AnimatedSprite2D.play("shotgun_slow_walk")
		elif Input.is_action_pressed("ui_shift"):
			player_speed = RUN_SPEED
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
			
		if velocity == Vector2(0,0) && !reloading:
			match current_weapon:
				"rifle":
					$AnimatedSprite2D.play("rifle_idle")
				"pistol":
					$AnimatedSprite2D.play("pistol_idle")
				"shotgun":
					$AnimatedSprite2D.play("shotgun_idle")
			
		
	var input_direction = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	)
	var vector = player_speed * input_direction
	velocity = vector.rotated(self.rotation +PI/2)
	move_and_slide()
	
func update_reloading():
	if Input.is_action_just_pressed("reload") && !reloading:
		match current_weapon:
			"rifle":
				reload_rifle()
			"pistol":
				reload_pistol()
			"shotgun":
				reload_shotgun()
		
func update_player_direction():
	mouse_position = get_local_mouse_position()
	if InputEventMouseMotion:
		var angle = (previous_position.y - mouse_position.y) * MOUSE_SENSITIVITY
		self.rotation = angle
		
func _physics_process(_delta: float) -> void:
	update_player_direction()
	update_reloading()
	update_player_movement()
	update_player_shooting()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("weapon_1"):
		current_weapon = "rifle"
	elif Input.is_action_pressed("weapon_2"):
		current_weapon = "pistol"
	elif Input.is_action_pressed("weapon_3"):
		current_weapon = "shotgun"
			
func _ready() -> void:
	previous_position = Vector2(0,-1) 
	$AnimatedSprite2D.play("rifle_idle")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 
	$MuzzleFlash/AnimatedSprite2D.visible = false
	current_weapon = "rifle"
	
func _on_animated_sprite_2d_animation_finished() -> void:
	reloading = false
	print("animation finsihed")
