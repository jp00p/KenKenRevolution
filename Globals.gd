extends Node

var music_notes := []
var bpms := 0.0
signal beat(pos)
signal measure(pos)

func _ready():
	for i in range(20):
		music_notes.append(0)
