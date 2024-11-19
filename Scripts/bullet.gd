extends CharacterBody2D

var direction_shot: Vector2
var speed = 3000

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity = direction_shot * speed * delta
	var collision_detect=move_and_collide(velocity)
	if collision_detect:
		if collision_detect.get_collider().name == "walls":
			queue_free()
		if collision_detect.get_collider().name == "Zombie":
			collision_detect.get_collider().health -= 1
			queue_free()
			
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('Walls'):
		queue_free()
	pass # Replace with function body.
