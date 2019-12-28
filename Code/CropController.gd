extends Spatial

var crop: Resource = load("res://Scenes/Crop.tscn")

var crop_timer: float = 0.0
var stage_times = [0.0, 2.0]
var stage_meshes = []

var next_stage: int = 1 #Holds the current stage of the crop

#CROP PROPERTIES
var growth_rate: float = 0.1

func init_stage_meshes() -> void:
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.albedo_color = Color(randf(), randf(), randf())
	var pm: PrismMesh = PrismMesh.new()
	var cm: CubeMesh = CubeMesh.new()
	var sm: SphereMesh = SphereMesh.new()
	pm.material = mat
	cm.material = mat
	sm.material = mat
	stage_meshes.append(pm)
	stage_meshes.append(cm)
	#stage_meshes.append(sm)	

func _ready() -> void:
	growth_rate = rand_range(0.5, 1.0)
	init_stage_meshes()
	set_mesh(0)
	
func set_mesh(index: int) -> void:
	$MeshInstance.mesh = stage_meshes[index]

#Handles behaviour when a crop is set to die.
func reproduce(max_angle: float) -> void:
	var foo: Spatial = crop.instance()
	get_parent().add_child(foo)
	foo.rotation = rotation #So basis is same as parent node's.
	var rand_axis: Vector3 = rand_range(-1, 1) * foo.transform.basis.x + rand_range(-1, 1) * foo.transform.basis.z
	rand_axis = rand_axis.normalized()
	var pos: Vector3 = translation.rotated(rand_axis, deg2rad(rand_range(0, max_angle)))
	foo.translation += pos

	""" var rand_axis: Vector3 = Vector3(rand_range(-1, 1), 0.0, rand_range(-1, 1)).normalized()
	var pos: Vector3 = Vector3(0, 20, 0).rotated(rand_axis, rand_range(0, 2 * 3.1415))
	foo.translate(pos)
	var normal: Vector3 = pos.normalized()
	var look_dir: Vector3 = normal.cross(Vector3.RIGHT).normalized()
	foo.look_at(foo.translation + look_dir * 100, normal) """
	queue_free()
		
func grow_crop(timer: float, delta: float) -> void:
	#If there are future stages available
	if next_stage != stage_times.size():
		scale += Vector3.ONE * growth_rate * delta
		if timer >= stage_times[next_stage]:
			set_mesh(next_stage)
			next_stage += 1
	else:
		reproduce(30)
		
	
	
func _physics_process(delta: float) -> void:
	crop_timer += delta
	grow_crop(crop_timer, delta)
	
	
	
	
	
	
	