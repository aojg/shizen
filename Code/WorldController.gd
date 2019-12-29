extends Spatial

var temperature: float = 15.0
var max_entities: int = 200
var num_entities = 0

var crop_arr = []

func get_max_entities() -> int:
	return max_entities

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
