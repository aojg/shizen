extends Spatial

const GROWTH_SPEED: float = 50.0

var crop_timer: float = 0.0
var stage_times = [5.0, 10.0, 20.0]
var stage_meshes = []

func _ready() -> void:
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.albedo_color = Color(randf(), randf(), randf())
	var cm: CubeMesh = CubeMesh.new()
	cm.material = mat
	stage_meshes.append(cm)
	
	$MeshInstance.set_surface_material(0, mat)
	
func set_mesh(crop_time: float) -> void:
	if crop_time >= stage_times[0]:
		$MeshInstance.mesh = stage_meshes[0]

func _physics_process(delta: float) -> void:
	crop_timer += delta
	set_mesh(crop_timer)