extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene

func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	#instancia interface de gameover e coleta valores da UI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	game_over_ui.enemies_defeated = game_ui.enemies_defeated
	game_over_ui.time_survived = game_ui.timer_label.text
	add_child(game_over_ui)

	if game_ui:
		game_ui.queue_free()
		game_ui = null
