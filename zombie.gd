extends CharacterBody2D

var move_speed = 100.0
@export var target: Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 10
var pursue = false
var attack = false
var anim
var dead = false
var count = 0
var damage = false



func _ready() -> void:
	$Sprite2D.play("idle")


func _physics_process(_delta: float) -> void:
	
	if dead == true:
		z_index = 0
		$CollisionShape2D.disabled = true
		dead = null
		health = 999
		velocity = Vector2(0,0)
		print("dead")
		$Sprite2D.play("dying1")
		print("000000")
	
	if dead == null:
		count += 1
		if count > 150:
			queue_free()
		pass
	
	elif health == 0 or health <= 0:
		dead = true
			#collision_detect.get_collider()
	elif attack:
		
		$Sprite2D.play(anim)
		if damage == true:
			print("player is hurt")
			damage = false
	elif pursue:
		move_speed = 150
		$Sprite2D.play("run")
		navigation_agent_2d.target_position = target.global_position
	else:
		if velocity == Vector2(0,0):
			$Sprite2D.play("idle")
		else:
			$Sprite2D.play("walk1")
			move_speed = 100
		
	if navigation_agent_2d.is_navigation_finished():
		velocity = Vector2(0,0)
		return
	if health > 0 and health < 100:
		var current_agent_position = global_position
		var next_path_position = navigation_agent_2d.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * move_speed
	
		self.rotation = -velocity.angle_to(Vector2(-1,0)) + PI
	
	
	
	
	#$Sprite2D.play("idle")
	
	

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.name == "Noisecircle":
		pursue = true
		navigation_agent_2d.target_position = target.global_position
	
	
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Noisecircle":
		pursue = false
		navigation_agent_2d.target_position = target.global_position
		print("exited)")
	pass # Replace with function body.


func _on_attack_zone_area_entered(area: Area2D) -> void:
	#decrease player health hereAAZqA
	print(area)
	var random_number = randi_range(1, 3)
	anim = "attack" + str(random_number)
	if area.name == "hitbox":
		attack = true
	pass # Replace with function body.
	



func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.name == "hitbox":
		attack = false
	pass # Replace with function body.



func _on_sprite_2d_animation_finished() -> void:
	damage = true
	pass # Replace with function body.
