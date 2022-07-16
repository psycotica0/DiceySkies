extends Node2D

var baseSpeed = 10
var level

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

onready var impulse = Accelerator.new(level.bounce, 0.0)

func _ready():
	pass # Replace with function body.

func on_collide(ship, normal):
	if normal.is_equal_approx(Vector2.DOWN):
		impulse = Accelerator.new(level.bounce, 1.0)
	
	ship.damage(1)

func _physics_process(delta):
	var speed = Vector2(0, level.timeScale * baseSpeed * delta)
	
	impulse.integrate(delta * level.timeScale)
	speed.y -= level.timeScale * impulse.value
	translate(speed)
