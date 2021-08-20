extends Node2D

var rotation_speed := PI

func _process(delta):
	$Pivot/Node2D.rotation += rotation_speed * delta
