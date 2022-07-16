extends StaticBody2D

export var active = false
export var speed = 32.0
var level
var last_target

const Shell = preload("res://Enemies/MortarShell.tscn")

func _ready():
	set_process(false)
	level = get_tree().root.get_child(0)

func _physics_process(_delta):
	if not active:
		return
#	prints(get_instance_id())
	last_target = level.target_point(global_position, speed)
	$Head.look_at(last_target)

func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	active = true
	$GunCooldown.start()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_GunCooldown_timeout():
	var levelSpace = level.currentLevel
#	var levelPos = levelSpace.local_position($Head/SpawnPoint.global_position)
	var shell = Shell.instance()
	shell.duration = global_position.distance_to(last_target) / speed
	levelSpace.add_child(shell)
	shell.global_position = last_target
