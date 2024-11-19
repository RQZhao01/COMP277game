extends CharacterBody2D

var move_speed = 100.0
@export var target: Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 10
var pursue = false

func _ready() -> void:
	$Sprite2D.play("idle")

	
		
		

func _physics_process(delta: float) -> void:
	
	 
	print(health)
	if health == 0:
		queue_free()
	if pursue:
		move_speed = 150
		$Sprite2D.play("run")
		navigation_agent_2d.target_position = target.global_position
	
	else:
		if velocity != Vector2(0,0):
			$Sprite2D.play("idle")
		else:
			$Sprite2D.play("walk1")
		
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * move_speed
	
	self.rotation = -velocity.angle_to(Vector2(-1,0)) + PI
	
	
	
	$Sprite2D.play("idle")
	
	

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.name == "Noisecircle":
		pursue = true
		navigation_agent_2d.target_position = target.global_position
		print("entered")
	
	
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Noisecircle":
		pursue = false
		navigation_agent_2d.target_position = target.global_position
		print("exited)")
	pass # Replace with function body.
