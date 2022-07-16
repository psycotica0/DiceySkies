extends KinematicBody2D

export (Curve) var accel
signal health_updated(health)
signal dead()

var level

var health = 6

class Accelerator:
	var progress = 0.0
	var scale = 1.0
	var raw_value = 0.0
	var value setget ,_get_value
	var done setget ,_get_done
	var curve
	
	func _init(c, s):
		curve = c
		scale = s
	
	func integrate(delta):
		if done:
			raw_value = 0.0
			return
			
		progress += delta
		raw_value = curve.interpolate_baked(progress)
	
	func _get_value():
		return raw_value * scale
	
	func _get_done():
		return progress > 1.0
	
	func stop():
		progress = 1.1
	

onready var left = Accelerator.new(accel, 0.0)
onready var right = Accelerator.new(accel, 0.0)
onready var up = Accelerator.new(accel, 0.0)
onready var down = Accelerator.new(accel, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()

func _physics_process(delta):
	var speed = Vector2.ZERO
	
	# Originally the timescale was a kind of time control
	# I've adjusted it to be throttle control, though, so I turn the same
	# speed
	left.integrate(delta) # * level.timeScale)
	speed.x -= left.value # level.timeScale * left.value
	
	right.integrate(delta) # * level.timeScale)
	speed.x += right.value # level.timeScale * right.value
	
	up.integrate(delta) # * level.timeScale)
	speed.y -= up.value # level.timeScale * up.value
	
	down.integrate(delta) # * level.timeScale)
	speed.y += down.value # level.timeScale * down.value
	
	var c = move_and_collide(speed, false)
	if not c:
		# I was seeing a weird thing where if I was going fast enough
		# then I'd get pushed without colliding
		c = move_and_collide(Vector2(0.0, -0.2), false, true, true)
	
	if c and c.collider:
		var obj = c.collider
		while obj and not obj.has_method("on_collide"):
			obj = obj.get_parent()
		if obj:
			obj.on_collide(self, c.normal)
		left.stop()
		right.stop()
		up.stop()
		down.stop()

func _on_Left_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index:
			if left.done:
				left = Accelerator.new(accel, level.currentDie)


func _on_Right_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index:
			if right.done:
				right = Accelerator.new(accel, level.currentDie)


func _on_Up_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index:
			if up.done:
				up = Accelerator.new(accel, level.currentDie)

func _on_Down_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index:
			if down.done:
				down = Accelerator.new(accel, level.currentDie)

func damage(amount):
	if not $DamageTimeout.is_stopped():
		return
	
	health -= amount
	if health < 1:
		emit_signal("dead")
	else:
		emit_signal("health_updated", health)
	
	$DamageTimeout.start()

func heal(amount):
	health += amount
	if health > 6:
		health = 1
	emit_signal("health_updated", health)
