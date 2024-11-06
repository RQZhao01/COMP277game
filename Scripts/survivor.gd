extends CharacterBody2D

class_name Survivor

var mouse_position
var previous_position
var x
var medkit_count: int = 0
const MAX_MEDKITS: int = 3
var delay: int = 0

var player_speed

@export var mouse_sensitivity = -0.005
@export var walk_speed: float = 250
@export var run_speed: float = 500
@export var slow_walk_speed: float = 125

func update_player_direction():
	mouse_position = (get_local_mouse_position())
	
	if InputEventMouseMotion:
		var angle = (previous_position.y - mouse_position.y) * mouse_sensitivity
		self.rotation = angle
		
	
func move_player():
	if Input.is_action_pressed("ui_ctrl"):
		player_speed = slow_walk_speed
		$AnimatedSprite2D.play("rifle_slow_walk")
	elif Input.is_action_pressed("ui_shift"):
		player_speed = run_speed
		$AnimatedSprite2D.play("rifle_run")
	else:
		player_speed = walk_speed
		$AnimatedSprite2D.play("rifle_walk")
		
	var input_direction = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
		)
		
	var vector = player_speed * input_direction
	velocity = vector.rotated(self.rotation +PI/2)
	
	if velocity != Vector2(0,0):
		$AnimatedSprite2D.play("rifle_move")
	else:
		$AnimatedSprite2D.play("rifle_idle")
	move_and_slide()
	
func update_player_shooting():
	delay +=1
	if Input.is_action_pressed("shoot") and delay > 5:
		shoot()
		delay = 0
	elif Input.is_action_just_released("shoot"):
		stop_shooting()
		
	
func _physics_process(delta: float) -> void:
	update_player_direction()
	move_player()
	update_player_shooting()
	
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
	
func _ready() -> void:
	previous_position = Vector2(0,-1)
	$AnimatedSprite2D.play("rifle_idle")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func shoot():
	$MuzzleFlash/AnimatedSprite2D.visible = true
	$MuzzleFlash/AnimatedSprite2D.play()
	var scene = load("res://Scenes/GunShootSound.tscn")
	var sound = scene.instantiate()
	add_child(sound)
	
func stop_shooting():
	$MuzzleFlash/AnimatedSprite2D.stop()
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
func _process(_delta: float) -> void:
	pass
