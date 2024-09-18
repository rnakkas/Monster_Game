extends CharacterBody2D

@onready var animation := $AnimatedSprite2D
@onready var raycast_right := $raycast_right
@onready var raycast_left := $raycast_left
@onready var enemy_headstomp_area = $enemy_headstomp_area

@export var speed: float = 60.0
@export var gravity: float = 980.0
@export var health: float = 2.0

var direction: int = 1

enum STATE {WALK, HURT, DEATH, ATTACK}
var current_state: STATE

func _set_state(new_state: STATE) -> void:
	match current_state:
		STATE.HURT, STATE.ATTACK:
			await animation.animation_finished
	#if current_state == STATE.HURT:
		#await animation.animation_finished
	_exit_state()
	current_state = new_state
	_enter_state()

func _exit_state() -> void:
	match current_state:
		STATE.WALK:
			pass
		STATE.HURT:
			pass
		STATE.ATTACK:
			pass

func _enter_state() -> void:
	match current_state: 
		STATE.WALK:
			_turn_collisions_on()
			animation.play("walk")
		STATE.HURT:
			_turn_collisions_off()
			health -= 1.0
			animation.play("hurt")
		STATE.DEATH:
			_turn_collisions_off()
			animation.play("death")
		STATE.ATTACK:
			_turn_collisions_on()
			animation.play("attack")

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
			
			##TODO: if player enters area, set state to attack
		
		STATE.HURT:
			if health <= 0.0:
				_set_state(STATE.DEATH)
			else:
				_set_state(STATE.WALK)
			
			##TODO: if player enters area, set state to attack
		
		STATE.ATTACK:
			pass
			##TODO: if player exits area, set state to walk
			
func _physics_process(delta) -> void:
	_update_state(delta)
	
func _ready() -> void:
	_set_state(STATE.WALK)

func _turn_collisions_off() -> void:
	self.set_collision_layer_value(1, 0)
	self.set_collision_mask_value(1, 0)
	enemy_headstomp_area.set_collision_mask_value(2, 0)
	enemy_headstomp_area.set_collision_layer_value(1, 0)

func _turn_collisions_on() -> void:
	self.set_collision_layer_value(1, 1)
	self.set_collision_mask_value(1, 1)
	enemy_headstomp_area.set_collision_mask_value(2, 1)
	enemy_headstomp_area.set_collision_layer_value(1, 1)

func _on_enemy_headstomp_area_body_entered(body):
	if body.name == "player":
		print("feet")
		_set_state(STATE.HURT)

func _on_hurt_player_area_body_entered(body):
	if body.name == "player":
		print ("attack")
		_set_state(STATE.ATTACK)

func _on_hurt_player_area_body_exited(body):
	if body.name == "player":
		print ("stop attack")
		_set_state(STATE.WALK)
