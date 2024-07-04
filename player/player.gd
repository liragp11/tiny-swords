extends CharacterBody2D

var input_vector: Vector2 = Vector2(0,0)
@export var speed: float = 3.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var attack_type = 1;

func _process(delta):
	read_input()
	update_animations()
	update_attack_cooldown(delta)

func read_input():
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")

	# Configuração de deadzone (controle)
	var dead_zone = 0.15
	if abs(input_vector.x) < dead_zone:
		input_vector.x = 0.0
	if abs(input_vector.y) < dead_zone:
		input_vector.y = 0.0
		
	# Atualizar variável de movimento
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func update_attack_cooldown(delta: float):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func _physics_process(delta):
	# Definir velocidade de movimento
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity,target_velocity, 0.05)
	move_and_slide()

func update_animations():
	# Alternar entre idle e run
	if not is_attacking:
		if was_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")

	# Definir rotação de sprite
	if input_vector.x > 0:
		sprite.flip_h = false;
	elif input_vector.x < 0:
		sprite.flip_h = true;
		
	# Validar se está atacando
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	if is_attacking:
		return

	if input_vector.y < 0:
		if attack_type == 1:
			animation_player.play("attack_up_1")
			attack_type = 2
		else:
			animation_player.play("attack_up_2")
			attack_type = 1
	elif input_vector.y > 0:
		if attack_type == 1:
			animation_player.play("attack_down_1")
			attack_type = 2
		else:
			animation_player.play("attack_down_2")
			attack_type = 1
	else:
		if attack_type == 1:
			animation_player.play("attack_side_1")
			attack_type = 2
		else:
			animation_player.play("attack_side_2")
			attack_type = 1

	attack_cooldown = 0.6
	is_attacking = true;
