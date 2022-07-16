extends KinematicBody2D

export var speed = 1.0
export var overWalls = true
export var damage = 1

var level

func _ready():
	set_collision_mask_bit(2, not overWalls)
	level = get_parent()

func _physics_process(delta):
	var c = move_and_collide(Vector2.DOWN * speed * delta * level.level.timeScale)
	if c:
		if c.collider.has_method("damage"):
			c.collider.damage(1)
#		get_parent().remove_child(self)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
#	get_parent().remove_child(self)
	queue_free()
