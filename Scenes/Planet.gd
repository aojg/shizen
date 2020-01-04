extends StaticBody

func set_color() -> void:
	var f: float = abs(clamp(get_parent().temperature, -15, 50) - 50) / 50
	var col: Color = Color.from_hsv(f / 2, 0.75, 1, 1)
	$MeshInstance.get_surface_material(0).albedo_color = col

func _physics_process(delta: float):
	set_color()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
