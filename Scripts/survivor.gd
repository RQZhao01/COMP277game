extends CharacterBody2D

class_name Survivor

var mouse_position

var looking_direction

var mouse_position2

var previous_position

var x

var medkit_count: int = 0

const MAX_MEDKITS: int = 3

@export var move_speed : float = 250

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#mouse_position = (get_global_mouse_position())
		##print(mouse_position)
		#look_at(mouse_position)
		##var mouse_player_angle = atan2(mouse_position.y, mouse_position.x)
		##rotation = mouse_player_angle


# THIS PART HAS PROBLEMS see if you can fix? the rotation is based on mouse iis wrong side
func _physics_process(delta: float) -> void:
	mouse_position = (get_local_mouse_position())
	#print(mouse_position)
	var mouse_position2 = mouse_position
	if InputEventMouseMotion:
		
		# the -0.005 is the sensitivty of the turning with the mouse, larger = higher sensitivty
		var angle = (previous_position.y-mouse_position2.y)*-0.005
		var angle2 = angle
		self.rotation = angle2

	if Input.is_action_pressed("ui_ctrl"):
		move_speed = 125
	elif Input.is_action_pressed("ui_shift"):
		#print("pressed")
		move_speed = 500
	else:
		move_speed = 250

	var input_direction = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up"))
	
	#velocity is a built in variable for characterbody 2d want to use
	# this to use move and slide which will help with collision detection
	var vector = move_speed * input_direction
	
	#dont touch the velocity
	velocity = vector.rotated(self.rotation +PI/2)
	
	if velocity != Vector2(0,0):
		$AnimatedSprite2D.play("rifle_move")
	else:
		$AnimatedSprite2D.play("rifle_idle")
		
	
	move_and_slide()
	#move and slide wil allow player to slide along the wall if there is collision object
	
func add_medkit(): #add metkit count
	if medkit_count < MAX_MEDKITS:
		medkit_count +=1
		print("get 1 medkit!!!!!!")
	else:
		pass
	
func use_medkit(): #decrease medkit count
	if medkit_count > 0:
		medkit_count -=1
		print("1 medkit used")
	else:
		print("no medkit left")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#previous_position = (get_global_mouse_position())-self.global_position
	previous_position = Vector2(0,-1)
	$AnimatedSprite2D.play("rifle_idle") # Replace with function body.+
	#hide the cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 
	$MuzzleFlash/AnimatedSprite2D.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		if Input.is_action_just_pressed("shoot"):
			$MuzzleFlash/AnimatedSprite2D.visible = true
			$MuzzleFlash/AnimatedSprite2D.play()
			$GunShootSound.play()
		elif Input.is_action_just_released("shoot"):
			$MuzzleFlash/AnimatedSprite2D.stop()
			$GunShootSound.stop()
			$MuzzleFlash/AnimatedSprite2D.visible = false
	
