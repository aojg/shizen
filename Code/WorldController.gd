extends Spatial

var temperature: float = 15.0
var max_entities: int = 200
var num_entities = 0

var crop_arr = []

var t: Timer = Timer.new()

func get_max_entities() -> int:
	return max_entities

func _ready() -> void:
	t.connect("timeout", self, "_on_timer_timeout")
	add_child(t)
	t.set_wait_time(1)
	t.start()

func get_average_perfect_temperature() -> float:
	var total: float = 0
	for i in crop_arr:
		total += i.perfect_temp
	if crop_arr.size() > 0:
		return total / crop_arr.size() 
	else:
		return 0.0

func _on_timer_timeout() -> void:
	print("Average ideal temperature: " + str(get_average_perfect_temperature()))
	print("New temperature is: " + str(temperature))
	print("Number of trees: " + str(crop_arr.size()))
	print("----------------------")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("temp_up"):
		temperature += 0.05
		print("Temperature is: " + str(temperature))
