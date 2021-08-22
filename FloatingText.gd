extends Node2D

export var text := "COOL"

func _ready():
	$Label.text = text

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
