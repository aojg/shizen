extends Spatial

func draw_lines(arr: Array, c: Color) -> void:
	var vertices: PoolVector3Array = PoolVector3Array(arr)
	var colors: PoolColorArray = PoolColorArray()
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	var arrays: Array = []
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true

	for i in range(vertices.size()):
		colors.append(c)

	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)

	var mesh_inst: MeshInstance = MeshInstance.new()
	mesh_inst.mesh = arr_mesh
	mesh_inst.set_surface_material(0, mat)
	self.add_child(mesh_inst)
