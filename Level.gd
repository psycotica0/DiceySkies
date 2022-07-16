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
	for _i in range(2):
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

func target_point(shooter, speed):
	var dy = $Ship.global_position.y - shooter.y
	var vs = -timeScale * currentLevel.baseSpeed
	var vs2 = pow(vs, 2)
	var vb2 = pow(speed, 2)
	var dx2 = pow($Ship.global_position.x - shooter.x, 2)
	var dy2 = pow(dy, 2)
	
	# I built an equation on paper and got Wolfram Alpha to solve it
	# This is what it spit out
	var t1 = (-sqrt(-dx2*vs2 + dx2 * vb2 + dy2*vb2) - dy*vs) / (vs2 - vb2)
	var t2 = (sqrt(-dx2*vs2 + dx2 * vb2 + dy2*vb2) - dy*vs) / (vs2 - vb2)
#	var t1 = -(sqrt(-dx2*vs2 + dx2 * vb2 + dy2*vb2) / (vs2 - vb2)) - (dy*vs) / (vs2 - vb2)
#	var t2 = (sqrt(-dx2*vs2 + dx2 * vb2 + dy2*vb2) / (vs2 - vb2)) - (dy*vs) / (vs2 - vb2)
	
	prints(t1, t2)
	if t1 > 0 or t2 > 0:
		var t
		if t1 > 0 and t2 > 0:
			t = min(t1, t2)
		elif t1 > 0:
			t = t1
		else:
			t = t2
		
		return $Ship.global_position + Vector2(0, vs * t)
#	prints(t)
	return $Ship.global_position
