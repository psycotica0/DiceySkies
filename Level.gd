extends Node2D

var currentDie
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

var currentLevelScene
var nextLevelScene
var nextLevel
var currentLevel
var startShipPos

# Called when the node enters the scene tree for the first time.
func _ready():
#	currentLevelScene = preload("res://Levels/SimpleTestLevel.tscn")
	currentLevelScene = preload("res://Levels/Level1.tscn")
#	currentLevelScene = preload("res://Levels/Gauntlet.tscn")
	startShipPos = $Ship.global_position
	randomize()
	fadedOut()
	# Extents
	var o = $CanvasLayer/Extents/TopLeft.get_global_transform()
	$Ship.top_left = get_viewport_transform().affine_inverse().xform(o.origin)
	var b = $CanvasLayer/Extents/BottomRight.get_global_transform()
#	prints(0.25 * (get_viewport_transform().inverse() * b.origin) , get_viewport_transform().affine_inverse().xform(b.origin))
	$Ship.bottom_right = get_viewport_transform().affine_inverse().xform($CanvasLayer/Extents/BottomRight.get_global_transform().origin)
#	prints($Ship.top_left, get_viewport_transform().affine_inverse().xform(o.origin))
	$CanvasLayer/Extents.visible = false
	load_level()

func add_die():
	var face = randi() % 6 + 1
	var die = Die.instance()
	die.face = face
	die.connect("pressed", self, "_on_die_pressed", [die])
	$CanvasLayer/DiceTray.add_child(die)

func load_level():
	$Ship.global_position = startShipPos
	if currentLevel:
		currentLevel.queue_free()
	if nextLevel:
		nextLevel.queue_free()
		nextLevel = null
	currentLevel = currentLevelScene.instance()
	currentLevel.level = self
	$LevelHolder.add_child(currentLevel)

func loadNextLevel(scene, offset):
	nextLevelScene = scene
	nextLevel = nextLevelScene.instance()
	nextLevel.position = $LevelHolder.to_local(offset)
	nextLevel.level = self
	prints("Load next", currentLevel, nextLevel)
	$LevelHolder.add_child(nextLevel)

func checkpoint():
	if not nextLevel:
		return
	
	prints("Checkpoint", currentLevel, nextLevel)
	currentLevel = nextLevel
	nextLevel = null
	currentLevelScene = nextLevelScene

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
#	$CanvasLayer/HBoxContainer/Health.text = str(health)
	$CanvasLayer/ShieldGauge.value = health


func fadedOut():
	$Ship.reset()
	throttle(2)
	$CanvasLayer/DiceTray2.reset()
	for _i in range(3):
		$CanvasLayer/DiceTray2.roll_die()
	load_level()
	$AnimationPlayer.play("FadeIn")

func _on_Ship_dead():
	$AnimationPlayer.play("FadeOut")

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
	
#	prints(t1, t2)
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

func player_pos():
	return $Ship.global_position


func _on_DiceTray2_diePicked(die):
	currentDie = die


func _on_ShieldReceiver_received(die):
	$Ship.heal(die.face)
	die.consume()


func _on_ThrottleReceiver_received(die):
	throttle(die.face)
	die.consume()

func throttle(value):
	timeScale = throttles[value]
	$CanvasLayer/ThrottleGauge.value = value

func _on_DiceTray2_tooManyDice():
	_on_Ship_dead()
