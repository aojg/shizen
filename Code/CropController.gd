extends Spatial

var crop: Resource = load("res://Scenes/Crop.tscn")

var crop_timer: float = 0.0
var death_time: float = 0.5

#CROP PROPERTIES
var max_growth_rate: float = 0.5
var ideal_temperature: float = 15
var ideal_humidity: float = 0.0

var mutation_chance: float = 0.01

var properties_arr = [ideal_temperature, ideal_humidity]
var weightings_arr = [0.5, 0.5]

func _ready() -> void:
	death_time = rand_range(2, 3)
	get_parent().crop_arr.append(self)
	print(set_random_weightings(properties_arr))

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
	var leaves: SpatialMaterial = SpatialMaterial.new()
	var bark: SpatialMaterial = SpatialMaterial.new()
	bark.albedo_color = Color(1, 1, 1)
	
	var red: Color = Color(1, 0, 0)
	var blue: Color = Color(0, 0, 1)
	var c: Color = blue.linear_interpolate(red, 30.0)
	leaves.albedo_color = c
	$MeshInstance.set_surface_material(0, leaves)
	$MeshInstance.set_surface_material(1, bark)
	
func set_traits(s: Spatial) -> void:
	if randf() < mutation_chance:
		s.ideal_temperature *= (1.0 + rand_range(-0.5, 0.5))
		s.ideal_humidity *= (1.0 + rand_range(-10, 10))
	else:
		s.ideal_temperature *= (1.0 + rand_range(-0.05, 0.05))
		s.ideal_humidity *= (1.0 + rand_range(-1, 1))

#Handles behaviour when a crop is set to die.
func reproduce(max_angle: float, max_seeds: int) -> void:
	if can_reproduce() == true:
		for i in range(max_seeds):
			#If the seed is successful
			var foo: Spatial = crop.instance()
			get_parent().add_child(foo)
			#So basis is same as parent node's.
			foo.rotation = rotation 
			#Create an axis to rotate foo's position vector around.
			var rand_axis: Vector3 = rand_range(-1, 1) * foo.transform.basis.x + rand_range(-1, 1) * foo.transform.basis.z
			rand_axis = rand_axis.normalized()
			var new_pos: Vector3 = translation.rotated(rand_axis, deg2rad(rand_range(0, max_angle)))
			var look_dir: Vector3 = new_pos.normalized().cross(Vector3.ONE)
			foo.translation += new_pos
			foo.look_at(foo.translation + look_dir * 100, new_pos.normalized()) 
			set_traits(foo)
			foo.set_mesh()
	kill()

func can_reproduce() -> bool:
	var temp_delta: float = ideal_temperature - get_parent().temperature
	var prob: float = 1 - (temp_delta)
	if randf() > prob:
		return false
	return true

#To be called when wanting to destroy a crop.
func kill() -> void:
	get_child(0).queue_free() #Delete child (timer).
	var i: int = get_parent().crop_arr.find(self)
	get_parent().crop_arr.remove(i)
	queue_free() #Queue for deletion.

func get_growth_rate(mgr: float) -> void:
	pass

func grow_crop(timer: float, delta: float) -> void:
	#If there are future stages available
	if timer < death_time:
		scale += Vector3.ONE * max_growth_rate * delta
	else:
		if randf() < 0.1:
			reproduce(30, 2)
		else:
			reproduce(30, 1)
					
func _physics_process(delta: float) -> void:
	crop_timer += delta
	grow_crop(crop_timer, delta)
	
	
	
	
	
	
	