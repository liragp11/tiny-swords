class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var enemies_label: Label = %EnemiesLabel

@export var restart_delay: float = 5.0
var restart_cooldown: float
var time_survived: String
var enemies_defeated: int

func _ready():
	time_label.text = time_survived
	enemies_label.text = str(enemies_defeated)
	restart_cooldown = restart_delay

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <=0:
		game_restart()

func game_restart():
	GameManager.reset()
	get_tree().reload_current_scene()
