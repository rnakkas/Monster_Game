extends CanvasLayer

func _ready() -> void:
	self.hide()


func _paused() -> void:
	get_tree().paused = true
	self.show()


func _on_resume_button_pressed():
	get_tree().paused = false
	self.hide()


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
