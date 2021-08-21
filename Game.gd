extends Node2D

onready var bg := $BG/TextureRect
var rotation_speed := 0.5
var bg_shader

signal game_beat(pos)
signal game_measure(pos)

func _ready():
	randomize()
	bg_shader = bg.get_material()
	
func _process(delta):
	$BG.rotation += -Globals.music_notes[0] * rotation_speed * delta
	$BG2.rotation += Globals.music_notes[2] * rotation_speed * delta
	bg_shader.set_shader_param("blur_scale", Vector2(-Globals.music_notes[1]*0.2,Globals.music_notes[1]*0.2))


func _on_Conductor_beat(position):
	emit_signal("game_beat", position)
	print("beat " + str(position))

func _on_Conductor_measure(position):
	emit_signal("game_measure", position)
	print("measure " + str(position))
