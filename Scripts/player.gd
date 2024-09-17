extends CharacterBody2D


@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -400.0
@export var gravity: float = 980

@onready var animation = $AnimatedSprite2D
@onready var pause_menu = %pause_menu

enum STATE {IDLE, RUN, JUMP, FALL}
var current_state : STATE

var direction: Vector2 = Vector2.ZERO

func _set_state(new_state: STATE) -> void:
	if current_state == new_state:
		return
	_exit_state()
	current_state = new_state
	_enter_state()

func _exit_state() -> void:
	match current_state:
		STATE.IDLE:
			pass
		STATE.RUN:
			pass
		STATE.JUMP:
			pass
		STATE.FALL:
			pass

func _enter_state() -> void:
	match current_state:
		STATE.IDLE:
			animation.play("idle")
		STATE.RUN:
			animation.play("run")
		STATE.JUMP:
			velocity.y = JUMP_VELOCITY
			animation.play("jump")
		STATE.FALL:
			animation.play("fall")

func _update_state(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up","move_down")
	match current_state:
		STATE.IDLE:
			if direction.x:
				_set_state(STATE.RUN)
			elif !is_on_floor():
				_set_state(STATE.FALL)
			elif Input.is_action_just_pressed("jump"):
				_set_state(STATE.JUMP)
			elif Input.is_action_just_pressed("pause"):
				_pause_game()
		
		STATE.RUN:
			velocity.x = direction.x * SPEED
			_flip_sprite()
			if !is_on_floor():
				_set_state(STATE.FALL)
			elif Input.is_action_just_pressed("jump"):
				_set_state(STATE.JUMP)
			elif velocity.x == 0:
				_set_state(STATE.IDLE)
			elif Input.is_action_just_pressed("pause"):
				_pause_game()
			
			move_and_slide()
		
		STATE.JUMP:
			velocity.x = direction.x * SPEED
			_flip_sprite()
			
			if !is_on_floor():
				velocity.y += gravity * delta
				if Input.is_action_just_pressed("pause"):
					_pause_game()
				if velocity.y > 0:
					_set_state(STATE.FALL)
			
			move_and_slide()
			
		STATE.FALL:
			velocity.x = direction.x * SPEED
			_flip_sprite()
			if Input.is_action_just_pressed("pause"):
					_pause_game()
			if is_on_floor():
				_set_state(STATE.IDLE)
			else:
				velocity.y += gravity * delta
				
			move_and_slide()
	
func _flip_sprite() -> void:
	if velocity.x > 0:
		animation.flip_h = false
	elif velocity.x < 0:
		animation.flip_h = true

func _ready() -> void:
	_set_state(STATE.IDLE)

func _physics_process(delta: float) -> void:
	_update_state(delta)
	
func _pause_game() -> void:
	pause_menu._paused()
	
