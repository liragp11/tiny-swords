class_name PassiveMob
extends Node2D

@export var health: int = 1
@export var death_prefab: Array[PackedScene]
@export var skull_color: Color = Color.WHITE;
@onready var character_body_2D: CharacterBody2D

func damage(amount: int):
	#diminuir vida do inimigo baseado no dano recebido
	health -= amount
	print("Player Damage: ", amount, " Enemy Health: ", health)
	
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
		var index: int = randi_range(0, death_prefab.size()-1)
		var death_object = death_prefab[index].instantiate()
		death_object.position = position
		death_object.modulate = skull_color
		get_parent().add_child(death_object)

	queue_free()
