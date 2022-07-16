extends Node2D

var currentDie = 1
var timeScale = 1.0

const Die = preload("res://DieControl.tscn")

const throttles = {
	1: 0.5,
	2: 1.0,
	3: 1.5,
	4: 2.0,
	5: 3.0,
	6: 4.0
}

export (Curve) var bounce

var currentLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = preload("res://Levels/SimpleTestLevel.tscn").instance()
	currentLevel.level = self
	$LevelHolder.add_child(currentLevel)
	$CanvasLayer/DiceTray/Dice1.consume()
	for i in range(2):
		add_die()

func add_die():
	var face = randi() % 6 + 1
	var die = Die.instance()
	die.face = face
	die.connect("pressed", self, "_on_die_pressed", [die])
	$CanvasLayer/DiceTray.add_child(die)

func _on_die_pressed(die):
	currentDie = die

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

func _on_Throttle_pressed():
	timeScale = throttles[currentDie.face]
	currentDie.consume()

func _on_Heal_pressed():
	$Ship.heal(currentDie.face)
	currentDie.consume()

func _on_Ship_health_updated(health):
	$CanvasLayer/HBoxContainer/Health.text = str(health)

func _on_Ship_dead():
	prints("Dead...")


func _on_DiceTimer_timeout():
	if $CanvasLayer/DiceTray.get_child_count() < 10:
		add_die()
	else:
		prints("Dead...")
