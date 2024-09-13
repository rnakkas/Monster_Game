extends CanvasLayer

func _ready():
	self.hide()

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.MAIN_MENU)
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _game_over() -> void:
	get_tree().paused = true
	self.show()
