extends Node

var plant_inst: Resource = load("res://Scenes/Plant.tscn")

func _ready() -> void:
	pass

func handle_camera_movement(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		CameraController.rotate_object_local(Vector3.UP, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_left"):
		CameraController.rotate_object_local(Vector3.DOWN, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_up"):
		CameraController.rotate_object_local(Vector3.LEFT, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_down"):
		CameraController.rotate_object_local(Vector3.RIGHT, CameraController.move_speed * delta)
	if Input.is_action_pressed("zoom_in"):
		CameraController.get_node("Camera").translate(Vector3.FORWARD * CameraController.zoom_speed * delta)
	if Input.is_action_pressed("zoom_out"):
		CameraController.get_node("Camera").translate(Vector3.BACK * CameraController.zoom_speed * delta)


func handle_trees() -> void:
	var d: Dictionary = CameraController.get_object_under_mouse()
	var hit: Vector3 = d.get("position")
	if Input.is_action_just_pressed("left_click") && hit != null:
		var tri_idx: int = Planet.get_node("Icosphere").find_closest_tri(hit)
		if Planet.get_tri_info(tri_idx, "plant") == null:
			var foo: Spatial = self.plant_inst.instance()
			self.get_node("/root/Universe").add_child(foo)
			foo.init_tree(tri_idx)
	if Input.is_action_just_pressed("right_click") && hit != null:
		var tri_idx: int = Planet.get_node("Icosphere").find_closest_tri(hit)
		var plant: Spatial = Planet.get_tri_info(tri_idx, "plant")
		if plant != null:
			plant.kill()
		

func _physics_process(delta: float) -> void:
	self.handle_camera_movement(delta)
	self.handle_trees()
