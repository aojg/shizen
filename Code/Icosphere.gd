extends Spatial

var tree: Resource = load("res://Scenes/Plant.tscn")
var material: SpatialMaterial = load("res://Materials/Default.tres")

#Vector3 array containing the centres of all mesh triangles.
var tri_centers: Array = []
var arr_mesh: ArrayMesh = ArrayMesh.new()

#An array of dictionaries holding the properties of all triangles in the mesh.

const X: float = 0.525731112119133606 
const Z: float = 0.850650808352039932

var surface_normals: Array = []
var cols: PoolColorArray = PoolColorArray()	
var verts: PoolVector3Array = PoolVector3Array()

var selection_mode: String = "single"

var old_tris: Array = []

#Vector3 array containing the vertices of an icosphere.
var icosphere_verts = [

	Vector3(-X, 0.0, Z), 
	Vector3(0.0, Z, X),
	Vector3(X, 0.0, Z),

	Vector3(-X, 0.0, Z),
	Vector3(-Z, X, 0.0),
	Vector3(0.0, Z, X),

	Vector3(-Z, X, 0.0),
	Vector3(0.0, Z, -X),
	Vector3(0.0, Z, X),

	Vector3(0.0, Z, X),
	Vector3(0.0, Z, -X),
	Vector3(Z, X, 0.0),

	Vector3(0.0, Z, X),
	Vector3(Z, X, 0.0),
	Vector3(X, 0.0, Z),

	Vector3(Z, X, 0.0),
	Vector3(Z, -X, 0.0),
	Vector3(X, 0.0, Z),

	Vector3(Z, X, 0.0),
	Vector3(X, 0.0, -Z),
	Vector3(Z, -X, 0.0),

	Vector3(0.0, Z, -X),
	Vector3(X, 0.0, -Z),
	Vector3(Z, X, 0.0),
	
	Vector3(0.0, Z, -X),
	Vector3(-X, 0.0, -Z),
	Vector3(X, 0.0, -Z),

	Vector3(-X, 0.0, -Z),
	Vector3(0.0, -Z, -X),
	Vector3(X, 0.0, -Z),

	Vector3(0.0, -Z, -X),
	Vector3(Z, -X, 0.0),
	Vector3(X, 0.0, -Z),
	
	Vector3(0.0, -Z, -X),
	Vector3(0.0, -Z, X),
	Vector3(Z, -X, 0.0),

	Vector3(0.0, -Z, -X),
	Vector3(-Z, -X, 0.0),
	Vector3(0.0, -Z, X),

	Vector3(-Z, -X, 0.0),
	Vector3(-X, 0.0, Z),
	Vector3(0.0, -Z, X),
	
	Vector3(-X, 0.0, Z),
	Vector3(X, 0.0, Z),
	Vector3(0.0, -Z, X),

	Vector3(0.0, -Z, X),
	Vector3(X, 0.0, Z),
	Vector3(Z, -X, 0.0),

	Vector3(-Z, X, 0.0),
	Vector3(-X, 0.0, Z),
	Vector3(-Z, -X, 0.0),

	Vector3(-Z, X, 0.0),
	Vector3(-Z, -X, 0.0),
	Vector3(-X, 0.0, -Z),

	Vector3(-Z, X, 0.0),
	Vector3(-X, 0.0, -Z),
	Vector3(0.0, Z, -X),

	Vector3(0.0, -Z, -X),
	Vector3(-X, 0.0, -Z),
	Vector3(-Z, -X, 0.0)
]	

func create_icosphere(arrays: Array, arr_mesh: ArrayMesh, mat: SpatialMaterial) -> void:
	#Setting up ArrayMesh
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	calculate_surface_normals()
	#Setting up MeshInstance
	var mesh_inst: MeshInstance = MeshInstance.new()
	mesh_inst.name = "IcoMeshInstance"
	mesh_inst.mesh = arr_mesh
	mesh_inst.set_surface_material(0, mat)

	add_child(mesh_inst)
	mesh_inst.create_trimesh_collision()


func update_icosphere(arr_mesh: ArrayMesh, mat: SpatialMaterial, vert_arr: PoolVector3Array, col_arr: PoolColorArray) -> void:
	var arrays: Array = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vert_arr
	arrays[ArrayMesh.ARRAY_COLOR] = col_arr
	arr_mesh.surface_remove(0)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	get_node("IcoMeshInstance").mesh = arr_mesh
	get_node("IcoMeshInstance").set_surface_material(0, mat)


#Returns a position Vector3 holding the center of the triangle at index idx.
func get_tri_center(tri_idx: int) -> Vector3:	
	return tri_centers[tri_idx]


func get_tri_count() -> int:
	return self.verts.size() / 3


func get_surface_normal(tri_idx: int) -> Vector3:
	return surface_normals[tri_idx]	


"""
Returns an int Array containing the indices of the 3 triangles adjacent to the triangle at tri_idx.
* tri_idx -- the index of the triangle we are finding the neighbours of.
* verts -- Vector3 array containing all vertices in the mesh.
"""
func get_neighbour_tris(tri_idx: int) -> Array:
	var adj_tri_indices: Array = []
	var tris_found: int = 0
	var tri_verts: Array = [verts[tri_idx*3], verts[tri_idx*3+1], verts[tri_idx*3+2]] 
	for i in range(0, verts.size(), 3):
		if tris_found == 3:
			break
		else:	
			var count: int = 0 #Counts of the number of shared vertices.
			for j in range(3):
				#Checking for shared vertices in the current triangle.
				if verts[i+j] == tri_verts[0] || verts[i+j] == tri_verts[1] || verts[i+j] == tri_verts[2]:
					count += 1
			if count == 2: #If 2 vertices are shared between triangles they must be neighbours.
				adj_tri_indices.append(i/3) #i/3 since it's a triangle index
				tris_found += 1	
	return adj_tri_indices			


func calculate_surface_normals() -> void:
	for i in range(0, verts.size(), 3):
		var u: Vector3 = verts[i+1] - verts[i]
		var v: Vector3 = verts[i+2] - verts[i]
		surface_normals.append(v.cross(u).normalized())		


#Returns the index of the triangle centre that is closest to the position hit.
func get_closest_tri(hit: Vector3) -> int:
	var tri_idx: int = 0
	var smallest_dist: float = self.tri_centers[tri_idx].distance_squared_to(hit)
	for i in range(self.tri_centers.size()):
		var temp: float = self.tri_centers[i].distance_squared_to(hit)
		if temp < smallest_dist:
			tri_idx = i
			smallest_dist = temp
	return tri_idx		
	
func subdivide_face(face_verts):
	var new_face_verts: Array = []
	for i in range(0, face_verts.size(), 3):
		var verts: Array = []
		verts.append(face_verts[i])
		verts.append(face_verts[i+1])
		verts.append(face_verts[i+2])
		verts = subdivide_triangle(verts)
		new_face_verts += verts
	return new_face_verts

#Returns a Vector3 array containing the centers of all triangles in the passed verts array.
#verts -- must be an array of Vector3 detailing vertices of triangles.
func find_tri_centers(verts: Array) -> Array:
	var tri_arr_old = []
	for i in range(0, verts.size(), 3):
		tri_arr_old.append((1.0/3.0) * (verts[i] + verts[i+1] + verts[i+2]))
	return tri_arr_old

#Iterates over verts with a chance of (prob*100)% to multiply an element by boost
func boost_vertices(verts: Array, prob: float, boost: float) -> Array:
	var tri_arr_old = []
	for i in range(verts.size()):
		if randf() < prob:
			tri_arr_old.append(verts[i])

	for i in range(verts.size()):
		for j in range(tri_arr_old.size()):
			if verts[i] == tri_arr_old[j]:
				verts[i] *= boost
	return verts			

#Subdivides a triangle returning a Vector3 array containing the vertices of the four new triangles.
func subdivide_triangle(tri_verts):
	var new_tri_verts = []
	var mp1: Vector3 = ((tri_verts[0] + tri_verts[1]) / 2.0).normalized()
	var mp2: Vector3 = ((tri_verts[1] + tri_verts[2]) / 2.0).normalized()
	var mp3: Vector3 = ((tri_verts[2] + tri_verts[0]) / 2.0).normalized()

	#Subdivided triangle 4 (centre triangle)
	new_tri_verts.append(mp1)
	new_tri_verts.append(mp2)
	new_tri_verts.append(mp3)

	#Subdivided triangle 1
	new_tri_verts.append(tri_verts[0].normalized())
	new_tri_verts.append(mp1)
	new_tri_verts.append(mp3)

	#Subdivided triangle 2
	new_tri_verts.append(mp1)
	new_tri_verts.append(tri_verts[1].normalized())
	new_tri_verts.append(mp2)

	#Subdivided triangle 3
	new_tri_verts.append(mp2)
	new_tri_verts.append(tri_verts[2].normalized())
	new_tri_verts.append(mp3)

	return new_tri_verts


#Size of tri_cols must be the same as the number of triangles.	
func set_ico_cols(tri_cols: Array) -> void:
	for tri_idx in range(tri_cols.size()):
		self.cols[tri_idx*3] = tri_cols[tri_idx]
		self.cols[tri_idx*3+1] = tri_cols[tri_idx]
		self.cols[tri_idx*3+2] = tri_cols[tri_idx]
	self.update_icosphere(self.arr_mesh, self.material, self.verts, self.cols)	


func set_selection_mode(mode: String) -> void:
	self.selection_mode = mode

func get_selected_tris(hit: Vector3) -> Array:
	var arr: Array = []
	var idx: int = self.get_closest_tri(hit)
	if self.selection_mode == "multi":
		arr += self.get_neighbour_tris(idx)
	arr.append(idx)
	return arr	


func highlight_selected_tris(hit: Vector3, enabled: bool = true) -> void:
	var tris: Array = get_selected_tris(hit)
	for tri in tris:
		self.cols[tri*3] *= 1.9
		self.cols[tri*3+1] *= 1.9
		self.cols[tri*3+2] *= 1.9

	if !self.old_tris.empty():
		for old_tri in self.old_tris:
			self.cols[old_tri*3] /= 1.9
			self.cols[old_tri*3+1] /= 1.9	
			self.cols[old_tri*3+2] /= 1.9	
	self.old_tris = tris		
	self.update_icosphere(self.arr_mesh, self.material, self.verts, self.cols)	


func _ready() -> void:

	for i in range(0, icosphere_verts.size(), 3):
		var face_verts: PoolVector3Array = PoolVector3Array()
		face_verts.append(icosphere_verts[i])
		face_verts.append(icosphere_verts[i+1])
		face_verts.append(icosphere_verts[i+2])
		for i in range(3):
			face_verts = subdivide_face(face_verts)
		verts += face_verts
	
	for i in range(verts.size()):
		cols.append(Color(0, 0, 0))	
	
	for i in range(0, verts.size()):
		verts[i] *= 40	
	verts = boost_vertices(verts, 0.05, 1.05)

	tri_centers = find_tri_centers(verts)
	#Settings up arrays

	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = verts
	arrays[ArrayMesh.ARRAY_COLOR] = cols

	self.create_icosphere(arrays, arr_mesh, material)





