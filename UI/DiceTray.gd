extends Control

signal diePicked(die)
signal tooManyDice()

func _ready():
	for child in $Buttons.get_children():
		child.active = false
		child.connect("picked", self, "_on_DiceButton_picked", [child])
	$AnimationPlayer.play("FlashRedDie")

func roll_die():
	var empty
	for child in $Buttons.get_children():
		if not child.active:
			empty = child
			break
	
	if not empty:
		emit_signal("tooManyDice")
		return
	
	empty.roll()

func reset():
	for child in $Buttons.get_children():
		child.active = false

func reshuffle():
	var empty
	for child in $Buttons.get_children():
		if child.active and empty:
			empty.face = child.face
			empty.active = child.active
			child.active = false
			empty = child
		elif not child.active:
			empty = child
		

func _on_DiceButton_picked(die):
	emit_signal("diePicked", die)

func _on_DiceButton_consumed():
	reshuffle()
	emit_signal("diePicked", null)

func _on_Timer_timeout():
	roll_die()
