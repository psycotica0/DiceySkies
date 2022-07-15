extends Node2D

var currentDie = 1
var timeScale = 1.0
export (Curve) var bounce

var currentLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = preload("res://Levels/SimpleTestLevel.tscn").instance()
	currentLevel.level = self
	$LevelHolder.add_child(currentLevel)

func _on_Dice1_pressed():
	currentDie = 1

func _on_Dice2_pressed():
	currentDie = 2

func _on_Dice3_pressed():
	currentDie = 3

func _on_Dice4_pressed():
	currentDie = 4

func _on_Dice5_pressed():
	currentDie = 5

func _on_Dice6_pressed():
	currentDie = 6
