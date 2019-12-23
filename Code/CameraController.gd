extends Camera

const MOVE_SPEED: float = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		get_parent().rotate_object_local(Vector3.UP, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_left"):
		get_parent().rotate_object_local(Vector3.DOWN, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_up"):
		get_parent().rotate_object_local(Vector3.RIGHT, MOVE_SPEED * delta)
	if Input.is_action_pressed("move_down"):
		get_parent().rotate_object_local(Vector3.LEFT, MOVE_SPEED * delta)
	
