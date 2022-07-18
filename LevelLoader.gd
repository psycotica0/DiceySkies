extends Node2D

export (Resource) var next_level

var level
var once = false

func _ready():
	level = get_tree().root.get_child(0)

func _on_VisibilityNotifier2D_screen_entered():
	if not once:
		once = true
		level.loadNextLevel(next_level, global_position)

func _on_VisibilityNotifier2D_screen_exited():
	if once:
		get_parent().queue_free()
