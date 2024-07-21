class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 1

@export_category("Death Animation")
@export var death_prefab: PackedScene
@export var skull_color: Color = Color.WHITE

@export_category("Drops")
@export var drop_items: Array[PackedScene]
@export var drop_chance: float = 0.1
@export var drop_chances: Array[float]

@onready var character_body_2D: CharacterBody2D
@onready var damage_marker = $DamageMarker
@onready var damage_audio = $DamageAudioRandomizer

var damage_digit_prefab: PackedScene

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int):
	#diminuir vida do inimigo baseado no dano recebido
	health -= amount

	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount

	if damage_marker:
		damage_digit.global_position = damage_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	print("Player Damage: ", amount, " Enemy Health: ", health)
	damage_audio.play()
	#Piscar em vermelho
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate", Color.WHITE,0.3)

	if health <=0:
		die()

func die():
	if GameManager.is_game_over: return
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		death_object.modulate = skull_color
		get_parent().add_child(death_object)
		GameManager.player.add_enemy_counter()
	
	if randf() <= drop_chance:
		drop_item()
	queue_free()
	
func drop_item():
	#instanciar item de drop
	var drop = get_random_drop().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
func get_random_drop() -> PackedScene:
	#Lista de drop com 1 item apenas
	if drop_items.size() == 1:
		return drop_items[0]
	
	#calcular chance máxima
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	#rolar dado
	var random_value = randf() * max_chance
	
	#girar roleta
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_items[0]
