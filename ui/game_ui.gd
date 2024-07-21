class_name GameUI
extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
#@onready var gold_label: Label = $GoldLabel
@onready var meat_label: Label = %MeatLabel
@onready var kills_label: Label = %KillsLabel
var timer_elapsed: float
var meat_counter: int = 0
var enemies_defeated: int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	GameManager.player.enemy_death.connect(on_enemy_death)
	meat_label.text = str(meat_counter)
	kills_label.text = str(enemies_defeated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_elapsed += delta
	var timer_elapsed_in_seconds: int = floori(timer_elapsed)
	var seconds = timer_elapsed_in_seconds % 60
	var minutes = timer_elapsed_in_seconds / 60
	
	timer_label.text = "%02d:%02d" % [minutes,seconds]

func on_meat_collected(value: int):
	meat_counter += 1
	meat_label.text = str(meat_counter)

func on_enemy_death():
	enemies_defeated +=1
	kills_label.text = str(enemies_defeated)

