extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_set.set_physics_layer_collision_layer(0,3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
