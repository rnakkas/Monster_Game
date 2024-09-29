extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %game_manager

func _ready() -> void:
	animation.play("closed")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.has_key:
			animation.play("open")
		else:
			print("find key")
