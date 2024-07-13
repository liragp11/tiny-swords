class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3.0
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 2
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export_category("Death Animation")
@export var death_prefab: PackedScene
@export var skull_color: Color = Color.WHITE;

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_type:int = 1;
var direction: int = 0;

var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0
#recebe valor da direção do ataque: -1 cima | 1 baixo | 0 laterais

func _process(delta):
	read_input()
	update_animations()
	update_attack_cooldown(delta)
	update_hitbox_detection(delta)
	update_ritual_cooldown(delta)
	#atribuído valor a variável global
	GameManager.player_position = position

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

func update_ritual_cooldown(delta: float):
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)

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
		direction = -1
		if attack_type == 1:
			animation_player.play("attack_up_1")
			attack_type = 2
		else:
			animation_player.play("attack_up_2")
			attack_type = 1
	elif input_vector.y > 0:
		direction = 1
		if attack_type == 1:
			animation_player.play("attack_down_1")
			attack_type = 2
		else:
			animation_player.play("attack_down_2")
			attack_type = 1
	else:
		direction = 0
		if attack_type == 1:
			animation_player.play("attack_side_1")
			attack_type = 2
		else:
			animation_player.play("attack_side_2")
			attack_type = 1

	attack_cooldown = 0.6
	is_attacking = true;

func deal_damage_to_enemy():
	#variável recebe área de efeito do ataque
	var bodies =  sword_area.get_overlapping_bodies()
	#se objeto na área de efeito for um inimigo
	#recebe dano
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body

			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if direction != 0:
				#cima: -1 | baixo: 1 (pq sim, o eixo y é invertido aqui '-')
				if direction == -1:
					attack_direction = Vector2.UP
				else:
					attack_direction = Vector2.DOWN
			else:
				if sprite.flip_h:
					attack_direction = Vector2.LEFT
				else:
					attack_direction = Vector2.RIGHT

			var dot_product = direction_to_enemy.dot(attack_direction)
			#print("Dot: ", dot_product)
			
			if dot_product >= 0.5:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta: float):
	#temporizador: cooldown diminui gradativamente a cada frame
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	#frequencia: a cada 0.5s o jogador recebe dano
	hitbox_cooldown = 0.5
	#detectar dano
	var bodies = hitbox_area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			#futuramente cada inimigo terá um valor de dano diferente
			damage(1)

func damage(amount: int):
	if health <=0: return
	#diminuir vida do inimigo baseado no dano recebido
	health -= amount
	print("Enemy Damage: ", amount, " Player Health: ", health, "/", max_health)
	
	#Piscar em vermelho
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate", Color.WHITE,0.3)
	
	if health <=0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		death_object.modulate = skull_color
		get_parent().add_child(death_object)
	
	print("Player veio a óbito T-T")
	queue_free()

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	print("Healed! ", health, "/", max_health)
	
	modulate = Color.GREEN
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate", Color.WHITE,0.3)
