extends Control

export (bool) var active setget _set_active
export (int, "Red", "Green", "Yellow", "Grey") var colour
export (int, 1, 6) var face setget _set_face

signal consumed()
signal picked()

func _ready():
	set_colour()

func set_colour():
	match colour:
		0:
			self.modulate = Color("ff0000")
		1:
			self.modulate = Color("56a049")
		2:
			self.modulate = Color("ffff00")
		3:
			self.modulate = Color("505050")

func _set_face(value):
	face = value
	for i in range(1,7):
		var child = $White.find_node(str(i))
		child.visible = (i == value)

func _set_active(value):
	active = value
	visible = active

func _on_1_pressed():
	emit_signal("picked")


func _on_2_pressed():
	emit_signal("picked")


func _on_3_pressed():
	emit_signal("picked")


func _on_4_pressed():
	emit_signal("picked")


func _on_5_pressed():
	emit_signal("picked")


func _on_6_pressed():
	emit_signal("picked")

func roll():
	self.face = (randi() % 6) + 1
	self.active = true

func consume():
	self.active = false
	emit_signal("consumed")
