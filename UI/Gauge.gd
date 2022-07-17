extends Control

export (int, 0, 6) var value setget _set_value, _get_value

func _ready():
	pass

func _set_value(new):
	value = new
	for i in range(1, 7):
		var child = find_node("Pip%d" % i)
		if not child:
			continue
		if i <= value:
			child.visible = true
		else:
			child.visible = false

func _get_value():
	return value
