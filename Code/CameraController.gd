extends Spatial

var move_speed: float = 5.0
var zoom_speed: float = 200.0

var max_dist: float = 200.0
var min_dist: float = 45.0

func can_zoom_out() -> bool:
	var t: float = $Camera.translation.z
	if t < self.max_dist:
		return true
	return false	

	
func can_zoom_in() -> bool:
	var t: float = $Camera.translation.z
	if t > self.min_dist:
		return true
	return false	

	
func get_object_under_mouse() -> Dictionary:
	var mouse_pos = self.get_viewport().get_mouse_position()
	var ray_from = $Camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * 1000.0
	var space_state = self.get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection

