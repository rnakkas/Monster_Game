extends Area2D

@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	animation.play("idle")

func _on_body_entered(body) -> void:
	if body.name == "player":
		animation.play("collect")
		# Wait for animtaion to finish before freeing queue
		await animation.animation_finished 
		queue_free()
