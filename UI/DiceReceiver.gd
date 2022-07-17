extends Control

signal received(die)
const bounds = Rect2(0,0,48,48)

var level
# I can't rely on signals because my child eats them
var mouse_over = false

func _ready():
	level = get_tree().root.get_child(0)
	$DiceButton.active = false

func _input(event):
	if event is InputEventMouseMotion:
		var local = get_local_mouse_position()
		var inside = bounds.has_point(local)
		if inside and not mouse_over:
			mouse_over = true
			_on_DiceReceiver_mouse_entered()
		elif not inside and mouse_over:
			mouse_over = false
			_on_DiceButton_mouse_exited()

func _on_DiceReceiver_mouse_entered():
	if level.currentDie:
		$DiceButton.face = level.currentDie.face
		$DiceButton.active = true

func _on_DiceButton_picked():
	emit_signal("received", level.currentDie)
	$DiceButton.active = false

func _on_DiceButton_mouse_exited():
	# This is a hack because enabling the child steals mouse from myself
	# So I enter on the parent and exit on the child
	$DiceButton.active = false
