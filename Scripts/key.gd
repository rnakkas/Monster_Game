extends Area2D

@onready var game_manager: Node = %game_manager
@onready var sprite: AnimatedSprite2D = $sprite
@onready var collect_sound: AudioStreamPlayer2D = $collect_sound

func _ready() -> void:
	sprite.play("idle")

# When player enter area, collect key and update key status
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		game_manager._update_key()
		collect_sound.play()
		var tween_one : Tween = get_tree().create_tween()
		var tween_two : Tween = get_tree().create_tween()
		tween_one.tween_property(self, "position", position - Vector2(0, 17), 0.4)
		tween_two.tween_property(self, "modulate:a", 0, 0.5)
		tween_one.tween_callback(queue_free)
		
