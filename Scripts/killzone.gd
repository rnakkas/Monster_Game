extends Area2D

@onready var timer = $Timer
@onready var game_over = %game_over

func _on_body_entered(body) -> void:
	if body.name == "player":
		timer.start()

func _on_timer_timeout() -> void:
	game_over._game_over()
