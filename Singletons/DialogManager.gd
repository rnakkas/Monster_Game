extends Node

@onready var text_box_scene = preload("res://Scenes/textbox.tscn")

var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func _start_dialog(position: Vector2, lines: Array[String]) -> void:
	if is_dialog_active:
		return
	
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box() -> void:
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box) # insert the text box into the game
	text_box.global_position = text_box_position # place text box in appropriate spot
	text_box._display_text(dialog_lines[current_line_index]) # to display the first line of the dialog line
	can_advance_line = false

func _on_text_box_finished_displaying() -> void:
	can_advance_line = true

func _unhandled_input(event) -> void:
	if (
		#event.is_action_pressed("jump") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		
		_show_text_box()
