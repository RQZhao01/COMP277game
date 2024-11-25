extends CharacterBody2D

var direction_shot: Vector2
var speed = 3000

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity = direction_shot * speed * delta
	var collision_detect=move_and_collide(velocity)
	if collision_detect:
		print(collision_detect.get_collider().name)
		
		if collision_detect.get_collider().name == "TileMap" or collision_detect.get_collider().name == "walls" :
			queue_free()
		#if collision_detect.get_collider().name == "Zombie":
			#collision_detect.get_collider().health -= 1
			#queue_free()
		if collision_detect.get_collider().name.substr(0,6) == "Zombie":
			collision_detect.get_collider().health -= 1
			collision_detect.get_collider().pursue = true
			#var scream = load("res://Scenes/Sounds/Zombie_screm.tscn")
			#var SCREAAAAAm = scream.instantiate()
			#collision_detect.get_collider().add_child(SCREAAAAAm)
			queue_free()
			
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('Walls'):
		queue_free()
	pass # Replace with function body.
