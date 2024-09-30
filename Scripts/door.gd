extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %game_manager
@onready var open_sound: AudioStreamPlayer2D = $open_sound
@onready var open_door_timer: Timer = $open_door_timer

const DOOR_LOCKED_LINE: Array[String] = ["You cannot leave without opening the chest!"]

func _ready() -> void:
	animation.play("closed")
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.chest_opened:
			Engine.time_scale = 0.5
			open_door_timer.start()
			open_sound.play()
			animation.play("open")
			await animation.animation_finished
			
		else:
			print("open the chest")
			DialogManager._start_dialog(global_position, DOOR_LOCKED_LINE)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if game_manager.chest_opened:
			animation.play("closing")

func _on_open_door_timer_timeout() -> void:
	Engine.time_scale = 1.0
	match get_tree().get_current_scene().get_name():
		"level_one":
			get_tree().change_scene_to_file("res://Scenes/level_two.tscn")
		"level_two":
			get_tree().change_scene_to_file("res://Scenes/level_three.tscn")
		
