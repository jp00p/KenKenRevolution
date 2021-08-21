extends Node2D

export var text := "COOL"

func _ready():
	$Label.text = text
