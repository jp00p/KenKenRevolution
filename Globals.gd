extends Node

var music_notes := []
var bpms := 0.0
var song_length = 0
var level = 1

var score := 0 setget set_score
var combo := 0 setget set_combo
var max_combo := 0
var rot_speed := 0.0

var purple = Color("#74569b")
var green = Color("#96fbc7")
var yellow = Color("#f7ffae")
var pink = Color("#ffb3cb")
var lavender = Color("#d8bfd8")

var all_colors = [purple, green, yellow, pink, lavender]
var foreground_colors = [green, yellow, pink, lavender]

onready var music = {
	1: preload("res://assets/puzzle-1-a.mp3"),
	2: preload("res://assets/puzzle-1-b.mp3"),
	3: preload("res://assets/DissonantWaltz.ogg"),
}

signal beat(pos)
signal measure(pos)
signal score_changed(score)
signal combo_changed(combo)

func _ready():
	for _i in range(20):
		music_notes.append(0)

func note_destroyed(points):
	var multi = 1
	if combo >= 5:
		multi = 2
	if combo >= 25:
		multi = 3
	if combo >= 50:
		multi = 5
	self.score += points * multi
	
func set_score(val):
	score = val
	emit_signal("score_changed", score)

func set_combo(val):
	combo = val
	max_combo += val
	emit_signal("combo_changed", combo)

func pick_random_color():
	return foreground_colors[randi()%foreground_colors.size()]
