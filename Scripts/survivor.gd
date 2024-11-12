extends CharacterBody2D

class_name Survivor

#States
var shooting = false
var reloading = false
var current_weapon: String = "rifle"

#consts
const MAX_MEDKITS: int = 3
const MAX_AMMO: int = 120
const MAX_MAG: int = 30
const MOUSE_SENSITIVITY = -0.005
const WALK_SPEED: float = 250
const RUN_SPEED: float = 500
const SLOW_WALK_SPEED: float = 125

var mouse_position
var previous_position
var medkit_count: int = 0
var ammo_count: int = 0
var mag_count: int = 0
var delay: int = 0
var player_speed


func reload():
	if mag_count < MAX_MAG and ammo_count > 0:
		reloading = true
		match current_weapon:
			"rifle":
				$AnimatedSprite2D.animation = "reload_rifle"
			"pistol":
				$AnimatedSprite2D.animation = "reload_pistol"
			"shotgun":
				$AnimatedSprite2D.animation = "reload_shotgun"
		
		$MuzzleFlash/AnimatedSprite2D.visible = false
		# calculate the ammo for reloadsa
		var needed_ammo = MAX_MAG - mag_count
		var ammo_to_reload = min(needed_ammo, ammo_count)
		ammo_count -= ammo_to_reload
		mag_count += ammo_to_reload
		print("Reloaded. Mag: ", mag_count, " Remaining ammo: ", ammo_count)
	elif ammo_count < MAX_MAG:
		print("Not enough ammo to reload!")
		
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
	if ammo_count < MAX_AMMO:
		ammo_count += 30
		ammo_count = min(ammo_count, MAX_AMMO)
		print("Picked up 30 ammo, current ammo count:", ammo_count)
	else:
		pass
		
func shoot():
	if mag_count > 0:
		mag_count -= 1
		print("Shots left in mag:", mag_count, " Total ammo remaining:", ammo_count)
		$MuzzleFlash/AnimatedSprite2D.visible = true
		$MuzzleFlash/AnimatedSprite2D.play()
		
		var scene = load("res://Scenes/GunShootSound.tscn")
		var sound = scene.instantiate()
		add_child(sound)
		match current_weapon:
			"rifle":
				shoot_rifle()
			"pistol":
				shoot_pistol()
			"shotgun":
				shoot_shotgun()
	else:
		$MuzzleFlash/AnimatedSprite2D.visible = false
		print("Out of ammo in mag, need to reload")
		
func stop_shooting():
	$MuzzleFlash/AnimatedSprite2D.stop()
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func shoot_rifle():
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
		
func shoot_pistol():
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
	
func shoot_shotgun():
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
	
func update_player_shooting():
	if !reloading:
		delay +=1
		if Input.is_action_pressed("shoot") and delay > 5:
			shoot()
			delay = 0
		elif Input.is_action_just_released("shoot"):
			stop_shooting()
			
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
		reload()
		
func update_player_direction():
	mouse_position = (get_local_mouse_position())
	if InputEventMouseMotion:
		var angle = (previous_position.y - mouse_position.y) * MOUSE_SENSITIVITY
		self.rotation = angle
		
func _physics_process(delta: float) -> void:
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
	
func _on_animated_sprite_2d_animation_finished() -> void:
	reloading = false
	print("animation finsihed")
	
