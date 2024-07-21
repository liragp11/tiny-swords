class_name Ritual
extends Node2D

@export var damage_amount: int = 1

@onready var area2D: Area2D = $Area2D

func _ready():
	GameManager.is_ritual_activated = true

func deal_damage():
	var bodies = area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(damage_amount)
		#else:
			#var mob: PassiveMob = body
			#mob.damage(damage_amount)
			
func ritual_deactivated():
	GameManager.is_ritual_activated = false
