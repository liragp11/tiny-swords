class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0

func _process(delta):
	if GameManager.is_game_over: return
	#Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	#Frequencia: Monstros por minuto
	var interval =  60.0 / mobs_per_minute
	cooldown = interval
	
	#Checar se ponto de spawn é dentro de alguma colisão
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	#coordenadas em bits da camadas de colisão do staticBody2D
	#1 para habilitado e 0 para desabilitado, leitura de trás para frente
	parameters.collision_mask = 0b1001
	var result: Array = world_state.intersect_point(parameters,1)
	if not result.is_empty(): return
	
	#instanciar uma criatura
	var index = randi_range(0, creatures.size()-1)
	var creature = creatures[index].instantiate()
	creature.global_position = point
	get_parent().add_child(creature)

func get_point() -> Vector2:
	#retorna um valor aleatório entre 0 e 1
	#que define o ponto do path2D
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
