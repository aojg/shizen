extends Spatial

#Array of dictionaries detailing information about mesh triangles.
var tri_info: Array = []

#Array of dictionaries detailing properties of triangles that impact the growth of crops.
var tri_attributes: Array = []

func _ready() -> void:
	self.init_tri_info(self.tri_info, get_node("Icosphere").get_tri_count())
	self.init_tri_attributes(self.tri_attributes, get_node("Icosphere").get_tri_count())

	var arr: Array = []
	for i in range(self.tri_attributes.size()):
		var f: float = self.tri_attributes[i].get("temp")
		f = range_lerp(f, -20, 40, 1, 0)
		arr.append(Color.from_hsv(0.5 * f, 0.8, 0.75))
	self.get_node("Icosphere").set_ico_cols(arr)

#Initialises an array of dictionaries which holds properties of mesh triangles.
func init_tri_info(tri_info: Array, tri_count: int) -> void:
	for i in range(tri_count):
		var d: Dictionary = {
			"occupied" : 0,
			"plant" : null
		}
		tri_info.append(d)

		
func inspect_triangle(tri_idx: int, temp_mode: String = "c") -> String:
	var s: String = ""
	var t: float = self.tri_attributes[tri_idx]["temp"]
	var t_string: String = ""
	match temp_mode:
		"f":
			t_string = str(t * 1.8 + 32) + "°F"
		"c":
			t_string = str(t) + "°C"	
		"k":
			t_string = str(t + 273.15) + "K"	
			
	s += "Temperature: " + t_string + "\n"
	return s
		

func init_tri_attributes(tri_attributes: Array, tri_count: int) -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(tri_count):
		var d: Dictionary = {
			"temp" : rng.randfn(15, 5)
		}
		if i <= 63:
			d["temp"] = rng.randfn(0, 5)
		tri_attributes.append(d)	

func get_tri_info(tri_idx: int, prop_name: String):
	return(self.tri_info[tri_idx].get(prop_name))


func set_tri_info(tri_idx: int, prop_name: String, val) -> void:
	self.tri_info[tri_idx][prop_name] = val


func set_tri_attribute(tri_idx: int, attrib_name: String, val) -> void:
	self.tri_attributes[tri_idx][attrib_name] = val


func get_tri_attribute(tri_idx: int, attrib_name: String):
	return(self.tri_attributes[tri_idx].get(attrib_name))


func get_tri_attributes(tri_idx: int) -> Array:
	return self.tri_attributes[tri_idx]	

