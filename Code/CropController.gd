extends Spatial

var crop: Resource = load("res://Scenes/Crop.tscn")

var crop_timer: float = 0.0

var death_time: float = 0.5

#CROP PROPERTIES
var growth_rate: float = 0
var seed_success_rate: float = 0 #Probability that a seed grows into a crop.
var disease_resistance: float = 0 #Probability that a crop doesn't die from disease.
var num_seeds: int = 0 #Number of seeds a crop will drop on death.

func _ready() -> void:
	var timer: Timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()
	timer.set_wait_time(3)
	death_time = rand_range(3, 5)
	get_parent().crop_arr.append(self)


#Randomises this seed's traits.
func set_random_traits() -> void:
	growth_rate = rand_range(0.0, 1.0)
	seed_success_rate = rand_range(0.5, 0.75)
	num_seeds = randi() % 5 + 3
	disease_resistance = randf()
		
func set_mesh() -> void:
	var leaves: SpatialMaterial = SpatialMaterial.new()
	var bark: SpatialMaterial = SpatialMaterial.new()
	bark.albedo_color = Color(1, 1, 1)
	#leaves.albedo_color = Color(clamp(growth_rate, 0, 1), clamp(seed_success_rate, 0, 1), clamp(num_seeds, 0, 1))
	leaves.albedo_color = Color(disease_resistance, 0, 0)
	$MeshInstance.set_surface_material(0, leaves)
	$MeshInstance.set_surface_material(1, bark)


#Handles behaviour when a crop is set to die.
func reproduce(max_angle: float, max_seeds: int) -> void:
	for i in range(max_seeds):
		#If the seed is successful
		if randf() < seed_success_rate && get_parent().num_entities < get_parent().get_max_entities():
			
			get_parent().num_entities += 1

			var foo: Spatial = crop.instance()
			get_parent().crop_arr.append(foo) #Add foo to the list of crops.

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

			foo.growth_rate = growth_rate 
			foo.seed_success_rate = seed_success_rate 
			foo.num_seeds = num_seeds
			foo.disease_resistance = disease_resistance * (1 + rand_range(-0.05, 0.5))
			foo.set_mesh()

	get_parent().crop_arr.erase(self)
	queue_free()
	get_parent().num_entities -= 1

#To be called when wanting to destroy a crop.
func kill() -> void:
	get_child(0).queue_free() #Delete child (timer).
	get_parent().crop_arr.erase(self) #Remove from list of crops.
	queue_free() #Queue for deletion.

func disease_chance() -> void:
	if randf() > disease_resistance:
		kill()

func grow_crop(timer: float, delta: float) -> void:
	#If there are future stages available
	if timer < death_time:
		scale += Vector3.ONE * growth_rate * delta
	else:
		reproduce(30, num_seeds)

func _on_timer_timeout() -> void:
	disease_chance()
		
func _physics_process(delta: float) -> void:
	crop_timer += delta
	grow_crop(crop_timer, delta)
	
	
	
	
	
	
	