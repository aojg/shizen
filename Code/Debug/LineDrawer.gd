extends Node

func _ready() -> void:
	self.draw_axises()

func draw_axises() -> void:
	var vertices: PoolVector3Array = PoolVector3Array()
	var cols: PoolColorArray = PoolColorArray()
	var mat: SpatialMaterial = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true

	vertices.push_back(Vector3.RIGHT * 100.0)
	vertices.push_back(Vector3.LEFT * 100.0)
	vertices.push_back(Vector3.UP * 100.0)
	vertices.push_back(Vector3.DOWN * 100.0)
	vertices.push_back(Vector3.FORWARD * 100.0)
	vertices.push_back(Vector3.BACK * 100.0)

	cols.push_back(Color(1, 0, 0))
	cols.push_back(Color(1, 0, 0))
	cols.push_back(Color(0, 1, 0))
	cols.push_back(Color(0, 1, 0))
	cols.push_back(Color(0, 0, 1))
	cols.push_back(Color(0, 0, 1))
		

	# Initialize the ArrayMesh.
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	var arrays: Array = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = cols
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	var mi: MeshInstance = MeshInstance.new()
	mi.mesh = arr_mesh
	mi.set_surface_material(0, mat)
	self.add_child(mi)
