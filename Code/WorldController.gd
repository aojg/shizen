extends Spatial

#WORLD PROPERTIES
var temperature: float = 15.0
var humidity: float = 0.0

var max_entities: int = 200

var crop_arr = []

var t: Timer = Timer.new()

func get_max_entities() -> int:
	return max_entities

func set_humidity(temp: float) -> void:
	humidity = temp * temp

func _ready() -> void:
	t.connect("timeout", self, "_on_timer_timeout")
	add_child(t)
	t.set_wait_time(1)
	t.start()

func get_average_ideal_temperature() -> float:
	var total: float = 0
	for i in crop_arr:
		total += i.ideal_temperature
	if crop_arr.size() > 0:
		return total / crop_arr.size() 
	else:
		return 0.0

func _on_timer_timeout() -> void:
	var rnd: float = randf()
	var multiplier: float = 1.0

	if rnd > 0.5:
		if randf() < 0.05:
			multiplier = 5.0
		temperature += multiplier * 0.1
	else:
		if randf() < 0.05:
			multiplier = 5.0
		temperature -= multiplier * 0.1

	set_humidity(temperature)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("temp_up"):
		t.set_wait_time(0.1)
	if Input.is_action_just_pressed("temp_down"):
		temperature -= 1
