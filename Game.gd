extends Node2D

onready var bg := $BG/TextureRect
var rotation_speed := 0.5
var bg_shader


signal game_beat(pos)
signal game_measure(pos)

func _ready():
	randomize()
	bg_shader = bg.get_material()
	Globals.connect("beat", self, "global_beat")
	Globals.connect("measure", self, "global_measure")
	
func _process(delta):
	$BG.rotation += -Globals.music_notes[0] * rotation_speed * delta
	$BG2.rotation += Globals.music_notes[2] * rotation_speed * delta
	bg_shader.set_shader_param("blur_scale", Vector2(-Globals.music_notes[1]*0.2,Globals.music_notes[1]*0.2))


func global_beat(beat):
	$UI/MarginContainer/HBoxContainer3/Beats.text = str(beat)
	emit_signal("game_beat", beat)
	

func global_measure(measure):
	$UI/MarginContainer/HBoxContainer3/Measure.text = str(measure)
	emit_signal("game_measure", measure)
