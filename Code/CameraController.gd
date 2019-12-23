extends Camera

const MOVE_SPEED: float = 2.5
var crop: Resource = load("res://Scenes/Crop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = project_ray_origin(mouse_pos)
	var ray_to = ray_from + project_ray_normal(mouse_pos) * 100.0
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		var foo: Spatial = crop.instance()
		foo.growth_direction = get_object_under_mouse().get("normal")
		foo.translate(get_object_under_mouse().get("position"))
		get_parent().get_parent().add_child(foo)
		
	if Input.is_action_pressed("move_right"):
		get_parent().rotate_object_local(Vector3.UP, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_left"):
		get_parent().rotate_object_local(Vector3.DOWN, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_up"):
		get_parent().rotate_object_local(Vector3.RIGHT, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_down"):
		get_parent().rotate_object_local(Vector3.LEFT, MOVE_SPEED * delta)
	
