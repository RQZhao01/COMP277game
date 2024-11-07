extends Area2D

var direction_shot: Vector2
var speed = 3000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(",,,,,,,,,", direction_shot)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = position + direction_shot * speed * delta
	
	pass
