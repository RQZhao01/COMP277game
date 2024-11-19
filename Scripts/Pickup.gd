extends Area2D

func _on_body_entered(body):
	if body is Survivor:  # Check if the body is the Survivor node
		if body.medkit_count < body.MAX_MEDKITS:
		#pick up 
			#print("Survivor collided with the pickup!")
			body.add_medkit()
			queue_free()  # Remove the picked thign
		else:
			print("max reached")
