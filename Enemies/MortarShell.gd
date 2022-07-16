extends Node2D

export var duration = 1.0
export var damage = 1

func _ready():
	$AnimationPlayer.play("Countdown", -1, 1.0 / duration)

func boom():
	for b in $Area2D.get_overlapping_bodies():
		if b.has_method("damage"):
			b.damage(damage)
	
	get_parent().remove_child(self)
	queue_free()
