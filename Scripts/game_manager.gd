extends Node

var has_key: bool = false
var chest_opened: bool = true

func _update_key() -> void:
	has_key = true

func _update_chest_opened() -> void:
	chest_opened = true
