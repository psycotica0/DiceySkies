extends StaticBody2D

export var onWall = false
export var active = false
export var speed = 16.0
var level

const Flak = preload("res://Enemies/Flak.tscn")

func _ready():
	set_process(false)
	level = get_tree().root.get_child(0)

func _physics_process(_delta):
	if not active:
		return
#	prints(get_instance_id())
	var target = level.target_point(global_position, speed)
	$Head.look_at(target)

func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	active = true
	$GunCooldown.start()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_WallDetector_body_entered(_body):
	onWall = true

func _on_GunCooldown_timeout():
	var levelSpace = level.currentLevel
#	var levelPos = levelSpace.local_position($Head/SpawnPoint.global_position)
	var flak = Flak.instance()
	flak.add_collision_exception_with(self)
	flak.speed = speed
	flak.overWalls = onWall
	levelSpace.add_child(flak)
	flak.global_position = $Head/SpawnPoint.global_position
	flak.rotation = $Head.rotation + PI/2.0
