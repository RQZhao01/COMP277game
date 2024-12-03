extends CharacterBody2D

var move_speed = 100.0
@export var target: Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0

var health = 5
var pursue = false
var attack = false
var anim
var dead = false
var count = 0
var damage = false
var player
var blind = false
var scream = false




func _ready() -> void:
	target = self.get_parent().get_parent().find_child("Survivor")
	
	$Sprite2D.play("idle")
	


func _process(_delta: float) -> void:
	if name == "Zombie2":
		if $RayCast2D.is_colliding():
			print("colliding with")
			print($RayCast2D.get_collider().name)
	
	if $Sprite2D.animation == "idle" and $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	
	if $Sprite2D.animation != "idle" and $AudioStreamPlayer2D.playing == true:
		$AudioStreamPlayer2D.stop()
	
	var pos = self.get_parent().get_parent().find_child("Survivor").find_child("light").global_position - self.global_position
	$RayCast2D.target_position = pos
	$RayCast2D.rotation = -self.rotation
	
	#if $RayCast2D.is_colliding() == true:
		#if self.name == "Zombie2":
			#print($RayCast2D.get_collider().name)
	
	if dead == true:
		z_index = 0
		$CollisionShape2D.disabled = true
		dead = null
		health = 999
		velocity = Vector2(0,0)
		print("dead")
		print("000000")
		randomize()
		var random_number = randi() % 2
		if random_number == 0:
			var dead = load("res://Scenes/Sounds/Zombie_death.tscn")
			var DEAD = dead.instantiate()
			self.add_child(DEAD)
			$Sprite2D.play("dying1")
			
		else:
			var dead = load("res://Scenes/Sounds/Zombie_death.tscn")
			var DEAD = dead.instantiate()
			self.add_child(DEAD)
			$Sprite2D.play("dying2")
		$Area2D.get_node("CollisionShape2D").set_disabled(true)
		$"attack zone".get_node("CollisionShape2D").set_disabled(true)
		
		
	if dead == null:
		print("dead")
		pass
	
	
	elif health == 0 or health <= 0:
		dead = true
			#collision_detect.get_collider()
	elif attack:
		
		$Sprite2D.play(anim)
		if damage == true:
			print("player is hurt")
			player.get_parent().current_health -= 25
			print(player.get_parent().current_health)
			damage = false
	elif $RayCast2D.is_colliding() and blind == false:
		
		if $RayCast2D.get_collider().name == "Survivor":
			move_speed = 400
			$Sprite2D.play("run")
			navigation_agent_2d.target_position = target.global_position
			if scream == false:
				scream = load("res://Scenes/Sounds/Zombie_screm.tscn")
				var SCREAAAAAm = scream.instantiate()
				self.add_child(SCREAAAAAm)
				scream = true
			
			
		else:
			if velocity == Vector2(0,0):
				$Sprite2D.play("idle")
			else:
				$Sprite2D.play("walk1")
				scream = false
				move_speed = 100
		
			
	elif pursue:
		move_speed = 250
		$Sprite2D.play("run")
		navigation_agent_2d.target_position = target.global_position
		
		
	else:
		if velocity == Vector2(0,0):
			$Sprite2D.play("idle")
		else:
			$Sprite2D.play("walk1")
			
			scream = false
			move_speed = 100
		
	if navigation_agent_2d.is_navigation_finished():
		velocity = Vector2(0,0)
		return
	if health > 0 and health < 100:
		var current_agent_position = global_position
		var next_path_position = navigation_agent_2d.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * move_speed
	
		self.rotation = -velocity.angle_to(Vector2(-1,0)) + PI
	
	
		


	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.name == "Noisecircle":
		pursue = true
		if scream == false:
			var scream = load("res://Scenes/Sounds/Zombie_screm.tscn")
			var SCREAAAAAm = scream.instantiate()
			self.add_child(SCREAAAAAm)
			scream = true
		#print(target.global_position)
		navigation_agent_2d.target_position = target.global_position
	
	
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Noisecircle":
		pursue = false
		navigation_agent_2d.target_position = target.global_position
		print("exited)")
	pass # Replace with function body.


func _on_attack_zone_area_entered(area: Area2D) -> void:
	#decrease player health here
	
	var random_number = randi_range(1, 3)
	anim = "attack" + str(random_number)
	if area.name == "hitbox":
		player = area
		attack = true
	if area.name.substr(0,8) == "darkroom":
		blind = true
		navigation_agent_2d.target_position = self.global_position
	pass # Replace with function body.
	



func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.name == "hitbox":
		attack = false
	if area.name.substr(0,8) == "darkroom":
		blind = false
		
	pass # Replace with function body.



func _on_sprite_2d_animation_finished() -> void:
	damage = true
	
	pass # Replace with function body.
