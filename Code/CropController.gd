extends Spatial

var crop: Resource = load("res://Scenes/Crop.tscn")

var crop_timer: float = 0.0
var death_time: float = 2.0

#CROP PROPERTIES
var max_growth_rate: float = 0.5

var crop_attributes: Dictionary = {
	"ideal_temp" : 15
}

var plant_mats: Array = []


#This is the index of the triangle that the crop is growing on.
var tri_idx: int = -1

#This is the surface normal of the triangle face that the crop is growing on.
var tri_normal: Vector3 = Vector3.ZERO

#These are the indices of the triangles that are adjacent to this crop.
var neighbour_indices: Array = []

#These are the Vector3 positions of the triangles adjacent to this crop.
var neighbour_positions: Array = []

var generation: int = 0


var ico: Spatial = null

func _ready() -> void:
	ico = self.get_node("../Icosphere")
	death_time = rand_range(0.5, 1.0)
	self.plant_mats = init_plant_mat_array(self.plant_mats)


func init_plant_mat_array(arr: Array) -> Array:
	for i in range(10):
		var spat_mat: SpatialMaterial = load("res://Materials/plant_" + str(i) + ".tres")
		spat_mat.albedo_color = Color.from_hsv(0.5 * (i/10.0), 0.8, 0.6)
		arr.append(spat_mat)
	return arr	


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
		if self.get_parent().get_tri_info(self.neighbour_indices[i], "occupied") == 0:
			foo.append(self.neighbour_indices[i])
		#We also want to add the triangle that the crop is growing on as a potential location for the child.
	if self.get_parent().get_tri_info(self.tri_idx, "occupied") == 0:
		foo.append(self.tri_idx)
	return foo		
	

func set_mesh() -> void:
	var idx: int = 0
	var t: float = self.crop_attributes.get("ideal_temp")

	if t >= 34 && t < 40:
		idx = 0
	elif t >= 28 && t < 34:
		idx = 1
	elif t >= 22 && t < 28:
		idx = 2
	elif t >= 16 && t < 22:
		idx = 3
	elif t >= 10 && t < 16:
		idx = 4		
	elif t >= 4 && t < 10:
		idx = 5
	elif t >= -2 && t < 4:
		idx = 6
	elif t >= -8 && t < -2:
		idx = 7
	elif t >= -14 && t < -8:
		idx = 8
	elif t >= -20 && t < -14:
		idx = 9				
	
	$MeshInstance.set_surface_material(0, self.plant_mats[idx])
	$MeshInstance.set_surface_material(1, self.plant_mats[idx])
	

#Handles behaviour when a crop is set to die.
func reproduce(max_seeds: int) -> void:
	self.get_parent().set_tri_info(tri_idx, "occupied", 0) 
	for i in range(max_seeds):
		self.create_crop()
	self.tri_idx = -1 #This is so when self is killed its tri_idx doesn't get marked as unoccupied again.
	self.kill()


func set_attributes(parent: Spatial, sd: float) -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var d: Dictionary = self.crop_attributes
	var multiplier: float = 1 + rng.randfn(0, sd)
	var foo: float = randf()
	if foo < 0.0001:
		multiplier = 1 + rng.randfn(0, sd*7)
	elif foo < 0.001:
		multiplier = 1 + rng.randfn(0, sd*5)
	elif foo < 0.01:
		multiplier = 1 + rng.randfn(0, sd*3)
		
	for i in range(d.keys().size()):
		self.crop_attributes[d.keys()[i]] = parent.crop_attributes[d.keys()[i]] * multiplier
		

func create_crop() -> void:
	var arr: Array = self.get_empty_neighbours()
	#If there is atleast 1 neighbour triangle that is empty.
	if arr.size() != 0:
		#Can foo grow on the triangle at index arr[r]?
		var r: int = randi() % arr.size()
		if self.can_grow(arr[r]):
			var foo: Spatial = crop.instance()
			self.get_parent().add_child(foo)
			#Marking the triangle as occupied.
			foo.set_tri_idx(arr[r])
			self.get_parent().set_tri_info(arr[r], "occupied", 1)
			foo.init_crop()
			foo.set_attributes(self, 0.025)
			foo.translate(ico.get_tri_center(arr[r]))
			var look_dir: Vector3 = foo.tri_normal.cross(Vector3.ONE)
			foo.look_at(foo.translation + look_dir * 100, foo.tri_normal)
			foo.set_mesh()


func can_grow(tri_idx: int) -> bool:
	var crop_vals: Array = self.crop_attributes.values()
	var tri_vals: Array = self.get_parent().get_tri_attributes(tri_idx).values()
	var total_delta: float = 0.0
	for i in range(crop_vals.size()):
		total_delta += pow(abs(crop_vals[i] - tri_vals[i]), 2.0) / max(abs(crop_vals[i]), abs(tri_vals[i]))
	if randf() > (total_delta / crop_vals.size()):
		return true	
	return false	


#To be called when wanting to destroy a crop.
func kill() -> void:
	if (self.tri_idx != -1):
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
	
	
	
	
	
	
	