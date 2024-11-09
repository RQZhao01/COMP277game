extends CharacterBody2D

var direction_shot: Vector2
var speed = 3000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(",,,,,,,,,", direction_shot)
	pass # Replace with function body.





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	velocity = direction_shot * speed * delta
	var collision_detect=move_and_collide(velocity)
	if collision_detect:
		print(collision_detect.get_collider())
		print(collision_detect.get_collider_id())
		print(collision_detect.get_class())
		queue_free()
	
	
	
	pass


func _on_area_entered(area: Area2D) -> void:
	print("111111111111111111111111111111111")
	if area.is_in_group('Walls'):
		print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("")
	print("mmmmmmmmmmmmmmmmmm")
	print(area)
	print("")
	pass # Replace with function body.
