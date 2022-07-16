extends TextureButton

export (int, 1, 6) var face setget _set_face

func _ready():
	pass

func _set_face(value):
	face = value
	$AnimationPlayer.play("set%d" % value)

func consume():
	get_parent().remove_child(self)
	self.queue_free()
