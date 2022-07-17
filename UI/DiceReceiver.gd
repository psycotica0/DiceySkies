extends Control

signal received(die)

var level

func _ready():
	level = get_tree().root.get_child(0)
	$DiceButton.active = false

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
