extends Node2D

onready var bg1 := $BG
onready var bg2 := $BG2
onready var bg3 := $BG3
onready var star_obj := preload("res://Star.tscn")
onready var note := preload("res://Note.tscn")
var bgs := []
var rotation_speed := 0.5
var bg_shader
var stars := []

var level = Globals.level

var songs = {
	1: [
		[0,1,1,0],
		[1,1,1,0],
		[0,1,1,1],
		[1,1,1,1],
	],
	2: [
		[1,1,0,1],
		[1,0,2,0],
		[2,1,0,0],
		[1,2,2,1],
	],
	3: [  # spooky waltz
		[1,2,2,0],
		[1,1,1,2],
		[0,2,0,2],
		[1,1,3,1],
	],
}

var song_length

# all songs start with 8 beats of no notes
var beat_one = 0
var beat_two = 0
var beat_three = 0
var beat_four = 0


signal game_beat(pos)
signal game_measure(pos)

func _ready():
	randomize()
	$Conductor.stream = Globals.music[level]
	song_length = floor($Conductor.stream.get_length() / $Conductor.sec_per_beat)
	Globals.connect("score_changed", self, "update_score")
	Globals.connect("combo_changed", self, "update_combo")
	Globals.connect("beat", self, "global_beat")
	Globals.connect("measure", self, "global_measure")
	bgs = [bg1, bg2, bg3]
	print(floor(song_length*0.25))
	load_stars()
	
func _process(delta):
	bg1.rotation += -Globals.music_notes[0] * rotation_speed * delta
	bg2.rotation += Globals.music_notes[10] * -rotation_speed * delta
	bg3.rotation += Globals.music_notes[19] * rotation_speed * delta

func global_beat(beat):
	emit_signal("game_beat", beat)
	print(beat)
	if beat > 8: # first 16 beats here (for a 96 beat song)
		$UI/Ready/ReadyText.set_visible(false)
		beat_one = songs[level][0][0]
		beat_two = songs[level][0][1]
		beat_three = songs[level][0][2]
		beat_four = songs[level][0][3]
	if beat > floor(song_length*0.25):
		beat_one = songs[level][1][0]
		beat_two = songs[level][1][1]
		beat_three = songs[level][1][2]
		beat_four = songs[level][1][3]
	if beat > floor(song_length*0.5):
		beat_one = songs[level][2][0]
		beat_two = songs[level][2][1]
		beat_three = songs[level][2][2]
		beat_four = songs[level][2][3]
	if beat > floor(song_length*0.75):
		beat_one = songs[level][3][0]
		beat_two = songs[level][3][1]
		beat_three = songs[level][3][2]
		beat_four = songs[level][3][3]
	if beat >= song_length-1:
		$Conductor.stop()
		$UI/Ready/FinishText.set_visible(true)
		pass
		# end of level
	
func spawn_notes(num):
	var ds = []
	for _i in range(num):
		var n = note.instance()
		var d = randi()%4
		while d in ds:
			d = randi()%4
		n.global_position = $NoteSpawn.global_position
		n.direction = d
		ds.append(d)
		add_child(n)
		

func global_measure(measure):
	emit_signal("game_measure", measure)
	match(measure):
		1: 
			spawn_notes(beat_one)
		2: 
			spawn_notes(beat_two)
		3: 
			spawn_notes(beat_three)
		4: 
			spawn_notes(beat_four)

func load_stars():
	var limits = Vector2(-300, 300)
	for bg in bgs:
		for c in [100, 50, 25]:
			for _i in range(c):
				var random_loc = Vector2(rand_range(limits.x, limits.y), rand_range(limits.x, limits.y))
				var star = star_obj.instance()
				star.global_position = random_loc
				bg.add_child(star)

func update_score(score):
	$UI/MarginContainer/Stats/VBoxContainer/Score/ScoreValue.text = str(score)

func update_combo(combo):
	var multi = 1
	if combo >= 5:
		multi = 2
	if combo >= 25:
		multi = 3
	if combo >= 50:
		multi = 5
	$UI/MarginContainer/Stats/Combo/ComboValue.text = str(combo)
	$UI/MarginContainer/Stats/VBoxContainer/ComboMult.text = "x"+str(multi)
