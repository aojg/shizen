extends Spatial




func _ready() -> void:
	for i in range($MultiMeshInstance.multimesh.instance_count):
		var t: Transform = Transform()
		if 
		t = t.translated(Vector3(1 * i, 0.0, 0.0))
		$MultiMeshInstance.multimesh.set_instance_transform(i, t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
