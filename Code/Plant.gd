extends Spatial

var crop_timer: float = 0.0
var death_time: float = 2.0

#CROP PROPERTIES
var max_growth_rate: float = 0.5

var crop_preferences: Dictionary = {
	"ideal_temp" : 15
}

var crop_attributes: Dictionary = {
	"fruit_yield": 1,
	"fruit_size": 1
}

var plant_mats: Array = []


#This is the index of the triangle that the crop is growing on.
var tri_idx: int = -1

#This is the surface normal of the triangle face that the crop is growing on.
var tri_normal: Vector3 = Vector3.ZERO

func _ready() -> void:
	death_time = rand_range(0.5, 1.0)
	self.plant_mats = init_plant_mat_array(self.plant_mats)


func init_plant_mat_array(arr: Array) -> Array:
	for i in range(10):
		var spat_mat: SpatialMaterial = load("res://Materials/plant_" + str(i) + ".tres")
		spat_mat.albedo_color = Color.from_hsv(0.5 * (i/10.0), 0.8, 0.6)
		arr.append(spat_mat)
	return arr	


func init_tree(tri_idx: int) -> void:	
	self.set_tri_idx(tri_idx)
	Planet.set_tri_info(tri_idx, "plant", self)
	self.translate(Planet.get_node("Icosphere").get_tri_center(tri_idx))
	var dir: Vector3 = self.tri_normal.cross(Vector3.ONE)
	self.look_at(translation + dir * 100.0, self.tri_normal)
	self.set_mesh()
	

func set_tri_idx(tri_idx: int) -> void:
	self.tri_idx = tri_idx
	self.tri_normal = Planet.get_node("Icosphere").get_surface_normal(tri_idx)


func set_mesh() -> void:
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.albedo_color = Color(1, 0, 0)
	$MeshInstance.set_surface_material(0, mat)
	$MeshInstance.set_surface_material(1, mat)
	

func set_attributes(parent: Spatial, sd: float) -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var d: Dictionary = self.crop_preferences
	var multiplier: float = 1 + rng.randfn(0, sd)
	var foo: float = randf()
	if foo < 0.0001:
		multiplier = 1 + rng.randfn(0, sd*7)
	elif foo < 0.001:
		multiplier = 1 + rng.randfn(0, sd*5)
	elif foo < 0.01:
		multiplier = 1 + rng.randfn(0, sd*3)
		
	for i in range(d.keys().size()):
		self.crop_preferences[d.keys()[i]] = parent.crop_preferences[d.keys()[i]] * multiplier
		

func can_grow(tri_idx: int) -> bool:
	var crop_vals: Array = self.crop_preferences.values()
	var tri_vals: Array = self.get_parent().get_tri_attributes(tri_idx).values()
	var total_delta: float = 0.0
	for i in range(crop_vals.size()):
		total_delta += pow(abs(crop_vals[i] - tri_vals[i]), 2.0) / max(abs(crop_vals[i]), abs(tri_vals[i]))
	return true	


#To be called when wanting to destroy a crop.
func kill() -> void:
	if self.tri_idx != -1:
		Planet.set_tri_info(self.tri_idx, "plant", null)
	self.queue_free() #Queue for deletion.


func grow_crop(timer: float, delta: float) -> void:
	#If there are future stages available
	if timer < death_time:
		scale += Vector3.ONE * max_growth_rate * delta
	
			
func _physics_process(delta: float) -> void:
	crop_timer += delta
	grow_crop(crop_timer, delta)
	
	
	
	
	
	
	