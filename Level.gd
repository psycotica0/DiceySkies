extends Node2D

var currentDie = 1
var timeScale = 1.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
