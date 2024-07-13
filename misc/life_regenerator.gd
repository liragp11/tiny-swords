extends Node2D

@export var regeneration_amount: int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		queue_free()
	
