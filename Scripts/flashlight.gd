extends PointLight2D
var light_on = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.get_node("CollisionShape2D").set_disabled(true)
	self.visible = false
	light_on = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		if light_on == true:
			$Area2D.get_node("CollisionShape2D").set_disabled(true)
			self.visible = false
			light_on = false
		else:
			$Area2D.get_node("CollisionShape2D").set_disabled(false)
			self.visible = true
			light_on = true
			
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for area in overlapping_bodies:
		print(area)
		if area.name.substr(0,6) == "Zombie":
			print("1")
			print(area)
			print(area.get_node("RayCast2D").is_colliding())
			if area.get_node("RayCast2D").is_colliding():
				print("2")
				if area.get_node("RayCast2D").get_collider().name == "Survivor":
					print("3")
					area.blind = false
