extends CharacterBody2D

@export var SPEED: float = 200.0
@export var knockback_speed: float = 100
@export var JUMP_VELOCITY: float = -350.0
@export var headstomp_bounce_velocity: float = -90.0
@export var gravity: float = 980
@export var health: float = 3.0

@onready var animation = $AnimatedSprite2D
@onready var pause_menu_1 = $pause_menu_1
@onready var game_over = $game_over

enum STATE {IDLE, RUN, JUMP, FALL, HEADSTOMP, HURT, DEATH}
var current_state : STATE

var hit_status: bool
var direction: Vector2 = Vector2.ZERO
var enemy: Node
var hit_direction: Vector2
var hit_velocity: Vector2

func _set_state(new_state: STATE) -> void:
	if current_state == new_state:
		return
	if current_state == STATE.HURT:
		await animation.animation_finished
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
		STATE.HEADSTOMP:
			pass
		STATE.HURT:
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
		STATE.HEADSTOMP:
			velocity.y = headstomp_bounce_velocity
			animation.play("jump")
		STATE.HURT:
			health -= 1.0 
			animation.play("hurt")
		STATE.DEATH:
			animation.play("death")
			game_over._game_over()

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
			elif hit_status:
				_set_state(STATE.HURT)
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
			elif hit_status:
				_set_state(STATE.HURT)
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
				if hit_status:
					_set_state(STATE.HURT)
			
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
		
		STATE.HEADSTOMP:
			velocity.x = direction.x * SPEED
			_flip_sprite()
			if !is_on_floor():
				velocity.y += gravity * delta
				if velocity.y > 0:
					_set_state(STATE.FALL)
			move_and_slide()
			
		STATE.HURT:
			velocity.x = -hit_direction.x * knockback_speed
			_flip_sprite()
			
			if !hit_status:
				_set_state(STATE.IDLE)
			elif !hit_status && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")):
				_set_state(STATE.RUN)
			elif !hit_status && Input.is_action_just_pressed("jump"):
				_set_state(STATE.JUMP)
			elif !hit_status && !is_on_floor():
				_set_state(STATE.FALL)
			elif health <= 0:
				_set_state(STATE.DEATH)
			
			move_and_slide()
	
func _flip_sprite() -> void:
	if velocity.x > 0 && current_state != STATE.HURT:
		animation.flip_h = false
	elif velocity.x < 0 && current_state != STATE.HURT:
		animation.flip_h = true
	elif hit_direction.x < 0:
		animation.flip_h = true
	elif hit_direction.x > 0:
		animation.flip_h = false

func _ready() -> void:
	_set_state(STATE.IDLE)

func _physics_process(delta: float) -> void:
	_update_state(delta)
	
func _pause_game() -> void:
	pause_menu_1._paused()

func _on_feet_area_entered(area):
	if area.name == "enemy_hurt_area":
		print("headstomp")
		_set_state(STATE.HEADSTOMP)

func _on_player_hurt_area_area_entered(area):
	if area.name == "enemy_attack_area":
		print("hit!")
		enemy = get_node("../human_man")
		hit_direction = (enemy.position - self.position).normalized()
		hit_status = true

func _on_player_hurt_area_area_exited(area):
	if area.name == "enemy_attack_area":
		print("not hit!")
		hit_status = false
