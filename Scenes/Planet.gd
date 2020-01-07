extends StaticBody


func create_solid() -> void:

	var phi: float = (1 + sqrt(5)) / 2.0
	var solid_verts = [

		Vector3(0, 1, phi),
		Vector3(0, -1, phi),
		Vector3(-phi, 0, 1),

		Vector3(0, -1, phi),
		Vector3(-1, -phi, 0),
		Vector3(-phi, 0, 1),

		Vector3(0, 1, phi),
		Vector3(-phi, 0, 1),
		Vector3(-1, phi, 0),

		Vector3(-phi, 0, 1),
		Vector3(-phi, 0, -1),
		Vector3(-1, phi, 0),

		Vector3(0, 1, phi),
		Vector3(0, -1, phi),
		Vector3(-phi, 0, 1),

		Vector3(-phi, 0, 1),
		Vector3(-1, -phi, 0),
		Vector3(-phi, 0, -1),

		Vector3(0, -1, phi),
		Vector3(1, -phi, 0),
		Vector3(-1, -phi, 0),

		Vector3(0, -1, phi),
		Vector3(phi, 0, 1),
		Vector3(1, -phi, 0),

		Vector3(phi, 0 ,1),
		Vector3(phi, 0, -1),
		Vector3(1, -phi, 0),

		Vector3(1, -phi, 0),
		Vector3(phi, 0, -1),
		Vector3(0, -1, -phi),

		Vector3(1, -phi, 0),
		Vector3(0, -1, -phi),
		Vector3(-1, -phi, 0),

		Vector3(0, 1, phi),
		Vector3(1, phi, 0),
		Vector3(phi, 0, 1),

		Vector3(0, 1, phi),
		Vector3(-1, phi, 0),
		Vector3(1, phi, 0),

		Vector3(1, phi, 0),
		Vector3(-1, phi, 0),
		Vector3(0, 1, -phi),

		Vector3(0, 1, -phi),
		Vector3(phi, 0, -1),
		Vector3(1, phi, 0),

		Vector3(phi, 0, 1),
		Vector3(1, phi, 0),
		Vector3(phi, 0, -1),

		Vector3(0, 1, phi),
		Vector3(phi, 0, 1),
		Vector3(0, -1, phi),

		Vector3(0, 1, -phi),
		Vector3(0, -1, -phi),
		Vector3(phi, 0, -1),

		Vector3(-1, phi, 0),
		Vector3(-phi, 0, -1),
		Vector3(0, 1, -phi),

		Vector3(-phi, 0, -1),
		Vector3(0, -1, -phi),
		Vector3(0, 1, -phi),

		Vector3(-phi, 0, -1),
		Vector3(-1, -phi, 0),
		Vector3(0, -1, -phi)
	]

	var new_solid_verts = []
	for i in range(0, solid_verts.size(), 3):
		var face_verts = []
		face_verts.append(solid_verts[i])
		face_verts.append(solid_verts[i+1])
		face_verts.append(solid_verts[i+2])
		for i in range(2):
			face_verts = subdivide_face(face_verts)
		new_solid_verts += face_verts

	var arr_mesh = ArrayMesh.new()
	var arrays = []

	var vertices = PoolVector3Array(new_solid_verts)
	
	var cols: PoolColorArray = PoolColorArray()

	var count: int = 0
	var current_col: Color = Color(0, 1, 0)
	current_col = Color.from_hsv(rand_range(0.17, 0.42), 0.75, randf())

	for i in range(vertices.size()):
		count += 1
		cols.append(current_col)
		if count % 3 == 0:
			current_col = Color.from_hsv(rand_range(0.17, 0.42), 0.75, randf())

	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = cols

	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = MeshInstance.new()
	m.mesh = arr_mesh
	m.set_surface_material(0, mat)
	m.create_trimesh_collision()
	add_child(m)

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

#Subdivides a triangle returning a Vector3 array containing the vertices of the four new triangles.
func subdivide_triangle(tri_verts):
	var new_tri_verts = []
	var mp1: Vector3 = ((tri_verts[0] + tri_verts[1]) / 2.0).normalized()
	var mp2: Vector3 = ((tri_verts[1] + tri_verts[2]) / 2.0).normalized()
	var mp3: Vector3 = ((tri_verts[2] + tri_verts[0]) / 2.0).normalized()

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

	#Subdivided triangle 4 (centre triangle)
	new_tri_verts.append(mp1)
	new_tri_verts.append(mp2)
	new_tri_verts.append(mp3)

	return new_tri_verts

func _ready() -> void:
	create_solid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
