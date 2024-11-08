extends CharacterBody2D

class_name Survivor

var mouse_position
var previous_position
var x
var medkit_count: int = 0
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
		
	
func update_player_movement():
	if reloading:
		player_speed = 50
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
	
