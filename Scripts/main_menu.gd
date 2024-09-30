extends Node2D

func _on_play_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_one.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
