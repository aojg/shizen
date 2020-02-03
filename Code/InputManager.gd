extends Node

var plant_inst: Resource = load("res://Scenes/Plant.tscn")

var input_mode: int = 0
"""
	* 0 -> inspect mode
	* 1 -> grow/harvest mode
"""

var info_ui: Control = null
var info_ui_2: Control = null

var selection_mode: int = 0
"""
	* 0 -> singular select
	* 1 -> multi-select
"""

var ico: Spatial = null


func _ready() -> void:
	self.ico = self.get_node("../Planet/Icosphere")
	self.info_ui = self.get_node("../InfoUI")
	self.info_ui_2 = self.get_node("../InfoUI2")

func handle_camera_movement(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		CameraController.rotate_object_local(Vector3.UP, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_left"):
		CameraController.rotate_object_local(Vector3.DOWN, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_up"):
		CameraController.rotate_object_local(Vector3.LEFT, CameraController.move_speed * delta)
	if Input.is_action_pressed("move_down"):
		CameraController.rotate_object_local(Vector3.RIGHT, CameraController.move_speed * delta)
	if Input.is_action_pressed("zoom_in") && CameraController.can_zoom_in():
		CameraController.get_node("Camera").translate(Vector3.FORWARD * CameraController.zoom_speed * delta)
	if Input.is_action_pressed("zoom_out") && CameraController.can_zoom_out():
		CameraController.get_node("Camera").translate(Vector3.BACK * CameraController.zoom_speed * delta)


func set_input_mode(i: int) -> void:
	self.input_mode = i

func handle_input_mode() -> void:
	if Input.is_action_just_pressed("mode_0"):
		self.set_input_mode(0)
	if Input.is_action_just_pressed("mode_1"):
		self.set_input_mode(1)


func handle_selection_mode() -> void:
	if Input.is_action_just_pressed("single_select"):
		self.ico.set_selection_mode("single")
	elif Input.is_action_just_pressed("multi_select"):
		self.ico.set_selection_mode("multi")


func handle_inspection() -> void:
	if self.input_mode == 0 && CameraController.get_object_under_mouse().has("position"):
		var hit: Vector3 = CameraController.get_object_under_mouse().get("position")
		if hit != null:
			self.info_ui.set_visibility(true)
			var tri_idx: int = self.ico.get_closest_tri(hit)
			var tri_info: String = self.ico.get_parent().inspect_triangle(tri_idx, "c")
			var mouse_pos: Vector2 = self.get_tree().get_root().get_mouse_position()
			self.info_ui.set_panel_text(tri_info)
			self.info_ui.set_panel_position(mouse_pos + Vector2(20, 20))
		else:
			self.info_ui.set_visibility(false)
	else:		
		self.info_ui.set_visibility(false)


func handle_highlighting(hit: Vector3) -> void:
	if hit != Vector3.ZERO:
		if self.input_mode == 0:
			self.ico.highlight_selected_tris(hit, true)
		elif self.input_mode == 1:
			self.ico.highlight_selected_tris(hit, true)



func handle_trees() -> void:
	if self.input_mode == 1 && !CameraController.get_object_under_mouse().empty():
		var d: Dictionary = CameraController.get_object_under_mouse()
		var hit: Vector3 = d.get("position")
		if Input.is_action_pressed("left_click"):
			var tris: Array = self.ico.get_selected_tris(hit)
			for tri in tris:
				if self.ico.get_parent().get_tri_info(tri, "plant") == null:
					var foo: Spatial = self.plant_inst.instance()
					self.get_node("/root/Universe").add_child(foo)
					foo.init_tree(tri)
		if Input.is_action_pressed("right_click"):
			var tris: Array = self.ico.get_selected_tris(hit)
			for tri in tris:
				var plant: Spatial = self.ico.get_parent().get_tri_info(tri, "plant")
				if plant != null:
					plant.kill()
		

func _physics_process(delta: float) -> void:
	var hit: Vector3 = Vector3.ZERO
	var d: Dictionary = CameraController.get_object_under_mouse()
	if !d.empty():
		hit = CameraController.get_object_under_mouse().get("position")
	self.handle_highlighting(hit)
	self.handle_inspection()
	self.handle_selection_mode()
	self.handle_camera_movement(delta)
	self.handle_trees()
	self.handle_input_mode()
