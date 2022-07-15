extends KinematicBody2D

export (Curve) var accel

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
	

onready var left = Accelerator.new(accel, 0.0)
onready var right = Accelerator.new(accel, 0.0)
onready var up = Accelerator.new(accel, 0.0)
onready var down = Accelerator.new(accel, 0.0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()

func _physics_process(delta):
	var speed = Vector2.ZERO
	
	left.integrate(delta * level.timeScale)
	speed.x -= left.value
	
	right.integrate(delta * level.timeScale)
	speed.x += right.value
	
	up.integrate(delta * level.timeScale)
	speed.y -= up.value
	
	down.integrate(delta * level.timeScale)
	speed.y += down.value
	
	var _c = move_and_collide(speed)

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
