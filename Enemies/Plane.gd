extends KinematicBody2D

export var speed = 36.0
export var maxTurn = 16.0
export var turnAccel = 8.0
export var active = false

const Bullet = preload("res://Enemies/Bullet.tscn")

var level
var x_speed = 0.0

func _ready():
	level = get_tree().root.get_child(0)
	set_process(false)

func _physics_process(delta):
	if not active:
		return
	
	var target = level.player_pos()
	var pos = global_position
	var dx = (target - pos).x
#	prints(target.distance_to(pos))
	
	if target.distance_to(pos) < 100:
		var s = sign(dx)
		if s == 0.0:
			s = float(((randi() % 2) * 2) - 1)
		# Avoiding
		dx -= s * 50
	
	var goal_speed = clamp(dx, -maxTurn, maxTurn)
	var goal_accel = clamp(goal_speed - x_speed, -turnAccel, turnAccel)
	
	x_speed += goal_accel
	var c = move_and_collide(Vector2(x_speed, speed) * delta)
	if c:
		if c.collider.has_method("damage"):
			c.collider.damage(1)
		damage(1)

func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	active = true
	$GunCooldown.start()

func _on_VisibilityNotifier2D_screen_exited():
	# This fires even if I'm removing myself because I blew up
	# So I have to not do it a second time
	if active:
		destroy()

func _on_GunCooldown_timeout():
	var levelSpace = level.currentLevel
#	var levelPos = levelSpace.local_position($Head/SpawnPoint.global_position)
	var bullet = Bullet.instance()
	bullet.add_collision_exception_with(self)
	bullet.speed = speed * 1.5
	bullet.overWalls = true
	levelSpace.add_child(bullet)
	bullet.global_position = $SpawnPoint.global_position

func damage(_v):
	$AnimationPlayer.play("Die")

func destroy():
	active = false
#	get_parent().remove_child(self)
	queue_free()
