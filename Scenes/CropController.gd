extends Spatial

var growth_direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.albedo_color = Color(randf(), randf(), randf())
	$MeshInstance.set_surface_material(0, mat)

func _physics_process(delta: float) -> void:
	scale += delta * -growth_direction * 5.0
