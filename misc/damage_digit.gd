extends Node2D

var value: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = str(value)
