extends CharacterBody2D

@onready var animation := $AnimatedSprite2D
@onready var raycast_right := $raycast_right
@onready var raycast_left := $raycast_left
@onready var enemy_attack_area = $enemy_attack_area
@onready var enemy_hurt_area = $enemy_hurt_area

@export var speed: float = 30.0
@export var chase_speed: float = 130.0
@export var gravity: float = 980.0
@export var health: float = 2.0

var direction: int = 1
var hurt_status: bool
var attack_status: bool
var chase_status: bool
var player_position: Vector2
var player_path : String = "../../player/player"

enum STATE {WALK, HURT, DEATH, ATTACK, CHASE}
var current_state: STATE

func _set_state(new_state: STATE) -> void:
	match current_state:
		STATE.HURT, STATE.ATTACK:
			await animation.animation_finished
	_exit_state()
	current_state = new_state
	_enter_state()

func _exit_state() -> void:
	match current_state:
		STATE.WALK:
			pass
		STATE.HURT:
			hurt_status = false
			pass
		STATE.ATTACK:
			pass
		STATE.CHASE:
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
		STATE.CHASE:
			_turn_collisions_on()
			animation.play("walk")

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
			
			if attack_status: # When player enters attack area
				_set_state(STATE.ATTACK)
			elif hurt_status: # When player jumps on head
				_set_state(STATE.HURT)
			elif chase_status: # When player enter agro area
				_set_state(STATE.CHASE)
		
		STATE.HURT:
			if health <= 0.0:
				_set_state(STATE.DEATH)
			elif chase_status:
				_set_state(STATE.CHASE)
			else:
				_set_state(STATE.WALK)
		
		STATE.ATTACK:
			if !attack_status && !chase_status:
				_set_state(STATE.WALK)
			elif !attack_status && chase_status:
				_set_state(STATE.CHASE)
		
		STATE.CHASE:
			if player_position.x > 0: # when attacked from the right
				direction = 1
				animation.flip_h = false
			elif player_position.x < 0: # when attacked from the left
				direction = -1
				animation.flip_h = true
				
			position.x += chase_speed * delta * direction
			
			if attack_status: # When player enters attack area
				_set_state(STATE.ATTACK)
			elif hurt_status: # When player jumps on head
				_set_state(STATE.HURT)
			elif !chase_status:
				_set_state(STATE.WALK)
			
func _physics_process(delta) -> void:
	_update_state(delta)
	
func _ready() -> void:
	_set_state(STATE.WALK)

func _turn_collisions_off() -> void:
	self.set_collision_layer_value(3, 0)
	enemy_hurt_area.set_collision_layer_value(4,0)
	enemy_attack_area.set_collision_layer_value(3, 0)
	enemy_attack_area.set_collision_mask_value(2, 0)

func _turn_collisions_on() -> void:
	self.set_collision_layer_value(3, 1)
	enemy_hurt_area.set_collision_layer_value(4,1)
	enemy_attack_area.set_collision_layer_value(3, 1)
	enemy_attack_area.set_collision_mask_value(2, 1)

func _on_enemy_attack_area_body_entered(body):
	if body.name == "player":
		print ("attack")
		attack_status = true

func _on_enemy_attack_area_body_exited(body):
	if body.name == "player":
		print ("stop attack")
		attack_status = false

func _on_enemy_hurt_area_body_entered(body) -> void:
	if body.name == "player":
		print("feet")
		hurt_status = true

func _on_enemy_hurt_area_area_entered(area):
	if area.name == "feet":
		print("test feet")
		hurt_status = true

func _on_agro_area_body_entered(body):
	if body.name == "player":
		print("agro")
		# get player position
		var player = get_node(player_path)
		player_position = (player.position - self.position)
		chase_status = true

func _on_agro_area_body_exited(body):
	if body.name == "player":
		print("no agro")
		chase_status = false
