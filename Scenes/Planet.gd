extends StaticBody

var crop: Resource = load("res://Scenes/Crop.tscn")
var tri_centers: Array = []

const X: float = 0.525731112119133606 
const Z: float = 0.850650808352039932
var cols: PoolColorArray = PoolColorArray()		
var verts: PoolVector3Array = PoolVector3Array()	

var icosphere_verts: Array = [
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

func create_icosphere(arrays: Array) -> void:
	#Configuring material
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true

	#Setting up ArrayMesh
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	#Setting up MeshInstance
	var mesh_inst: MeshInstance = MeshInstance.new()
	mesh_inst.name = "IcoMeshInstance"
	mesh_inst.mesh = arr_mesh
	mesh_inst.set_surface_material(0, mat)

	add_child(mesh_inst)
	mesh_inst.create_trimesh_collision()

#Returns a position Vector3 holding the center of the triangle at index idx.
func get_center_pos_idx(idx: int) -> Vector3:	
	return tri_centers[idx]

#Returns the indices of the 3 triangles adjacent to the triangle at tri_idx
func get_adj_tri_indices(tri_idx: int, v_arr: Array) -> Array:
	#Array of triangle vertices.
	var adj_tri_indices: Array = []
	var tris_found: int = 0
	var tri_verts: Array = [v_arr[tri_idx*3], v_arr[tri_idx*3+1], v_arr[tri_idx*3+2]] 
	for i in range(0, v_arr.size(), 3):
		if tris_found == 3:
			break
		else:	
			var count: int = 0
			for j in range(3):
				if v_arr[i+j] == tri_verts[0] || v_arr[i+j] == tri_verts[1] || v_arr[i+j] == tri_verts[2]:
					count += 1
			if count == 2:
				adj_tri_indices.append(i)
				tris_found += 1	
	return adj_tri_indices			

func update_icosphere(vert_arr: PoolVector3Array, col_arr: PoolColorArray) -> void:
	var arr_mesh: ArrayMesh = ArrayMesh.new()

	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true
	var arrays: Array = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vert_arr
	arrays[ArrayMesh.ARRAY_COLOR] = col_arr

	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	get_node("IcoMeshInstance").mesh = arr_mesh
	get_node("IcoMeshInstance").set_surface_material(0, mat)


func find_closest_tri(hit: Vector3, tri_centers: Array) -> int:
	var dist_deltas: Array = []
	for i in range(tri_centers.size()):
		dist_deltas.append(tri_centers[i].distance_squared_to(hit))

	var smallest_dist_index: int = 0
	for i in range(1, dist_deltas.size()):
		if dist_deltas[i] < dist_deltas[smallest_dist_index]:
			smallest_dist_index = i
	print(smallest_dist_index)		
	return smallest_dist_index		
	
func subdivide_face(face_verts):
	var new_face_verts = []
	for i in range(0, face_verts.size(), 3):
		var verts = []
		verts.append(face_verts[i])
		verts.append(face_verts[i+1])
		verts.append(face_verts[i+2])
		verts = subdivide_triangle(verts)
		new_face_verts += verts
	return new_face_verts

#Returns a Vector3 array containing the centers of all triangles in the passed verts array.
#verts -- must be an array of Vector3 detailing vertices of triangles.
func find_tri_centers(verts: Array) -> Array:
	var arr = []
	for i in range(0, verts.size(), 3):
		arr.append((1.0/3.0) * (verts[i] + verts[i+1] + verts[i+2]))
	return arr

func boost_vertices(verts: Array, prob: float, boost: float) -> Array:
	var arr = []
	for i in range(verts.size()):
		if randf() < prob:
			arr.append(verts[i])

	for i in range(verts.size()):
		for j in range(arr.size()):
			if verts[i] == arr[j]:
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

func _ready() -> void:

	for i in range(0, icosphere_verts.size(), 3):
		var face_verts: PoolVector3Array = PoolVector3Array()
		face_verts.append(icosphere_verts[i])
		face_verts.append(icosphere_verts[i+1])
		face_verts.append(icosphere_verts[i+2])
		for i in range(2):
			face_verts = subdivide_face(face_verts)
		verts += face_verts
	
	for i in range(0, verts.size()):
		verts[i] *= 20	
	#verts = boost_vertices(verts, 0.05, 1.2)
	tri_centers = find_tri_centers(verts)

	for i in range(0,verts.size(),3):
		var col: Color = Color.from_hsv(0, 0.0, randf())
		cols.append(col)
		cols.append(col)
		cols.append(col)
	#Settings up arrays

	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = verts
	arrays[ArrayMesh.ARRAY_COLOR] = cols

	create_icosphere(arrays)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		var hit: Vector3 = get_node("Camera Container/Camera").get_object_under_mouse().get("position")
		var hit_normal: Vector3 = get_node("Camera Container/Camera").get_object_under_mouse().get("normal")
		if (hit != null):
			var idx: int = find_closest_tri(hit, tri_centers)
			var rand_col: Color = Color(randf(), randf(), randf())

			cols[idx*3] = rand_col
			cols[idx*3+1] = rand_col
			cols[idx*3+2] = rand_col

			var neighbours: Array = get_adj_tri_indices(idx, verts)
			for i in range(neighbours.size()):
				var c: Color = Color(randf(), randf(), randf())
				cols[neighbours[i]] = c	
				cols[neighbours[i]+1] = c
				cols[neighbours[i]+2] = c

			update_icosphere(verts, cols)

			#var foo: Spatial = crop.instance()
			#get_node("/root/Universe").add_child(foo)
			#foo.translate(get_center_pos_idx(idx))
			#var dir: Vector3 = hit_normal.cross(Vector3.RIGHT)
			#foo.look_at(foo.translation + dir * 100, hit_normal)
			#foo.set_mesh()

