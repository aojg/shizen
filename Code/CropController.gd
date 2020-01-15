extends Spatial

var crop: Resource = load("res://Scenes/Crop.tscn")

var mat_1: SpatialMaterial = load("res://Materials/Leaves.tres")

var crop_timer: float = 0.0
var death_time: float = 0.5

#CROP PROPERTIES
var max_growth_rate: float = 0.5
var crop_color: Color = Color(0, 0, 0)

var crop_attributes: Dictionary = {
	"ideal_temp" : 15
}


#This is the index of the triangle that the crop is growing on.
var tri_idx: int = 0

#This is the surface normal of the triangle face that the crop is growing on.
var tri_normal: Vector3 = Vector3.ZERO

#These are the indices of the triangles that are adjacent to this crop.
var neighbour_indices: Array = []

#These are the Vector3 positions of the triangles adjacent to this crop.
var neighbour_positions: Array = []

var ico: Spatial = null

func _ready() -> void:
	ico = self.get_node("../Icosphere")
	death_time = rand_range(2, 3)


func init_crop() -> void:
	self.neighbour_indices = ico.get_adj_tri_indices(self.tri_idx)

	for i in range(self.neighbour_indices.size()):
		self.neighbour_positions.append(ico.get_tri_center(self.neighbour_indices[i]))


func set_tri_idx(tri_idx: int) -> void:
	self.tri_idx = tri_idx
	self.tri_normal = ico.get_surface_normal(tri_idx)


func get_empty_neighbours() -> Array:	
	var foo: Array = []
	for i in range(self.neighbour_indices.size()):
		#If the triangle doesn't have a crop growing in it.
		if get_parent().get_tri_info(self.neighbour_indices[i], "occupied") == 0:
			foo.append(self.neighbour_indices[i])
		#We also want to add the triangle that the crop is growing on as a potential location for the child.	
	return foo		
	

func set_random_weightings(prop_arr):
	var remaining_prob: float = 1.0
	var result = []
	for i in range(prop_arr.size()):
		if i == prop_arr.size() - 1:
			result.append(remaining_prob)
			break
		else:
			var prob: float = rand_range(0.0, remaining_prob)
			result.append(prob)
			remaining_prob -= prob
	return result	
		

func set_mesh() -> void:
	var m: SpatialMaterial = mat_1
	m.albedo_color = Color(1, 0, 0)
	$MeshInstance.set_surface_material(0, m)
	$MeshInstance.set_surface_material(1, m)
	

#Handles behaviour when a crop is set to die.
func reproduce(max_seeds: int) -> void:
	if can_reproduce() == true:
		for i in range(max_seeds):
			create_crop()
	kill()


func create_crop() -> void:
	var arr: Array = self.get_empty_neighbours()
	#If there is atleast 1 neighbour triangle that is empty.
	if arr.size() != 0:
		var foo: Spatial = crop.instance()
		get_parent().add_child(foo)
		var r: int = randi() % arr.size()
		foo.set_tri_idx(arr[r])
		#Marking the triangle as occupied.
		self.get_parent().set_tri_info(arr[r], "occupied", 1)
		foo.init_crop()
		foo.translate(ico.get_tri_center(arr[r]))
		var look_dir: Vector3 = foo.tri_normal.cross(Vector3.ONE)
		foo.look_at(foo.translation + look_dir * 100, foo.tri_normal)
		foo.set_mesh()


func can_reproduce() -> bool:
	var crop_vals: Array = self.crop_attributes.values()
	var tri_vals: Array = self.get_parent().get_tri_attribute_values(self.tri_idx)
	var total_delta: float = 0.0
	for i in range(crop_vals.size()):
		total_delta += abs(crop_vals[i] - tri_vals[i]) / max(abs(crop_vals[i]), abs(tri_vals[i]))
	if randf() > total_delta / crop_vals.size():
		return true	
	return false	



#To be called when wanting to destroy a crop.
func kill() -> void:
	self.get_parent().set_tri_info(tri_idx, "occupied", 0)
	self.queue_free() #Queue for deletion.


func get_growth_rate(mgr: float) -> void:
	pass


func grow_crop(timer: float, delta: float) -> void:
	#If there are future stages available
	if timer < death_time:
		scale += Vector3.ONE * max_growth_rate * delta
	else:
		if randf() < 0.1:
			reproduce(4)
		else:
			reproduce(3)
	
			
func _physics_process(delta: float) -> void:
	crop_timer += delta
	grow_crop(crop_timer, delta)
	
	
	
	
	
	
	