extends Control

func _ready() -> void:
	pass # Replace with function body.


func set_panel_text(s: String) -> void:
	$Text.text = s


func set_panel_position(pos: Vector2) -> void:
	self.rect_position = pos


func set_visibility(status: bool) -> void:	
	self.visible = status
