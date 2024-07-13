class_name Enemy
extends Node2D

@export var health: int = 1
@export var death_prefab: PackedScene
@export var skull_color: Color = Color.WHITE;

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
		var death_object = death_prefab.instantiate()
		death_object.position = position
		death_object.modulate = skull_color
		get_parent().add_child(death_object)

	queue_free()
