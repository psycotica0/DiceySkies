extends Area2D

var level
var baseSpeed = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()

func _physics_process(delta):
	translate(Vector2(0, baseSpeed * delta * level.timeScale))

func _on_VisibilityNotifier2D_screen_exited():
	prints("Gone Baby!")
	level.remove_child(self)
	self.queue_free()

func _on_Wall1_body_entered(_body):
	prints("Collided")
