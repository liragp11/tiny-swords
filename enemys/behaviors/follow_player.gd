extends Node
#Criado Node auxiliar para inclusão do script de comportamento follow_player
	#sem afetar propriedades individuais no script Enemy
@export var speed: float = 1

#Importando classe para acessar propriedades de CharacterBody2D
var enemy: Enemy
var sprite: AnimatedSprite2D
var sprite2: Sprite2D

func _ready():
	#get_parent: permite que o node utilize os atributos de outro node localmente
	enemy = get_parent();
	#get_node: a partir da variável que foi atribuída o get_parent,
		#pode-se utilizar os atributos dos nodes abaixo dele
	sprite = enemy.get_node("AnimatedSprite2D")
	sprite2 = enemy.get_node("Sprite2D")

func _physics_process(delta):
	if GameManager.is_game_over: return
	var position_player = GameManager.player_position
	var difference = position_player - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 100.0	
	enemy.move_and_slide()

	# Definir rotação de sprite
	if not sprite == null:
		if input_vector.x > 0:
			sprite.flip_h = false;
		elif input_vector.x < 0:
			sprite.flip_h = true;
	else:
		if input_vector.x > 0:
			sprite2.flip_h = false;
		elif input_vector.x < 0:
			sprite2.flip_h = true;
