extends Control

func set_text() -> void:
	var t: float = get_parent().temperature
	var n: int = get_parent().crop_arr.size()
	var avg_ideal_temp = get_parent().get_average_ideal_temperature()
	get_child(0).text = "---WORLD PROPERTIES---" + '\n'
	get_child(0).text += "Temperature: " + str(t) + '\n'
	get_child(0).text += "Humidity: " + str(get_parent().humidity) + '\n'
	get_child(0).text += '\n'
	get_child(0).text += "---ENTITY PROPERTIES---" + '\n'
	get_child(0).text += "Number of entities: " + str(n) + '\n'
	get_child(0).text += "Average ideal temperature: " + str(avg_ideal_temp) + '\n'

func _physics_process(delta: float) -> void:
	set_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
