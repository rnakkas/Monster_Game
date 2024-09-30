extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %game_manager
@onready var open_sound: AudioStreamPlayer2D = $open_sound

const CHEST_LOCKED_LINE: Array[String] = ["Locked! You need to find the key!"]
const CHEST_EMPTY_LINE: Array[String] = ["Darn! It's empty! Maybe it's in another part of the castle..."]

func _ready() -> void:
	animation.play("closed")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.has_key:
			open_sound.play()
			animation.play("open")
			game_manager._update_chest_opened()
			DialogManager._start_dialog(global_position, CHEST_EMPTY_LINE)
		else:
			DialogManager._start_dialog(global_position, CHEST_LOCKED_LINE)
