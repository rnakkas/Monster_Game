extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %game_manager

const DOOR_LOCKED_LINE: Array[String] = ["You cannot leave without opening the chest!"]

func _ready() -> void:
	animation.play("closed")
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.chest_opened:
			animation.play("open")
		else:
			print("open the chest")
			DialogManager._start_dialog(global_position, DOOR_LOCKED_LINE)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.chest_opened:
			animation.play("closing")
