extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var raycast_right = $raycast_right
@onready var raycast_left = $raycast_left
@onready var enemy_headstomp_area = $enemy_headstomp_area


@export var speed = 30
@export var gravity = 980
var direction: int = 1

enum STATE {WALK, HURT, DEATH}
var current_state: STATE
var health: float = 2.0

func _set_state(new_state: STATE) -> void:
	#if current_state == new_state:
		#return
	_exit_state()
	current_state = new_state
	_enter_state()

func _exit_state() -> void:
	match current_state:
		STATE.WALK:
			pass
		STATE.HURT:
			pass

func _enter_state() -> void:
	match current_state: 
		STATE.WALK:
			animation.play("walk")
		STATE.HURT:
			animation.play("hurt")
		STATE.DEATH:
			animation.play("death")

func _update_state(delta: float) -> void:
	match current_state:
		STATE.WALK:
			if raycast_left.is_colliding():
				direction = 1
				animation.flip_h = false
			elif raycast_right.is_colliding():
				direction = -1
				animation.flip_h = true
			position.x += speed * delta * direction
		
		STATE.HURT:
			health -= 1.0
			if health <= 0.0:
				_set_state(STATE.DEATH)
			else:
				_set_state(STATE.WALK)
		
		STATE.DEATH:
			self.set_collision_layer_value(1, 0)
			self.set_collision_mask_value(1, 0)
			enemy_headstomp_area.set_collision_mask_value(1, 0)
			enemy_headstomp_area.set_collision_mask_value(2, 0)
			
			
func _physics_process(delta) -> void:
	_update_state(delta)
	
func _ready() -> void:
	_set_state(STATE.WALK)

func _on_enemy_headstomp_area_body_entered(body):
	if body.name == "player":
		print("sdfsd")
		_set_state(STATE.HURT)
