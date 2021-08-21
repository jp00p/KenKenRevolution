extends Node2D

var max_keys := 25
var total_keys := 0
onready var rotation_speed := Globals.bpms * 2.5 # syncing to beat
var indicator_colliding := false
var colliding_key = null
var perfect := false
var good := false
var okay := false
var direction_map := { "up":0, "right": 1, "down": 2, "left":3 }
var safe_to_drop := true

# will need a different pattern per song
var song_pattern := {
	0: [false, "left", "down", "right"],
	15: ["left", "down", false, "down"],
	25: ["down", "down", "up", "up"]
}

var mi := [] # { 0, 35, 75, ... } measure index
var mp := 0 # measure position... confusing
var current_pattern := 0 # 0, 35, 75...
var pattern_index := 0 # 0, 1, 2, 3...

onready var key := preload("res://Key.tscn")
onready var floating_text := preload("res://FloatingText.tscn")
onready var indicator := $Pivot/Node2D/Indicator

signal rotator_beat

func _ready():
	randomize()
	Globals.connect("beat", self, "on_beat")
	Globals.connect("measure", self, "on_measure")
	mi = song_pattern.keys()


func _process(delta):
	$Pivot/Node2D.rotation += rotation_speed * delta
	$Pivot/Node2D/Indicator.rotation += rotation_speed * delta
	if perfect:
		$Pivot/Label.text = "perfect"
	elif good:
		$Pivot/Label.text = "good"
	elif okay:
		$Pivot/Label.text = "okay"
	else:
		$Pivot/Label.text = ""


func _unhandled_input(event):
	if colliding_key == null or !colliding_key.is_ready:
		return
	
	var rank = ""
	var score = 0
	
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(colliding_key.key_required):
			if perfect:
				rank = "Perfect!"
				score = 100
			elif good:
				rank = "Good!"
				score = 50
			elif okay:
				rank = "Okay!"
				score = 25

		else:
			rank = "Miss!"
			score = 0
			
		var ft = floating_text.instance()
		ft.text = rank
		ft.position = indicator.global_position
		add_child(ft)
		colliding_key.destroy(10)
		total_keys = max(total_keys - 1, 0)
		_reset()


func on_beat(pos):
	
	var key_to_play = false
	if song_pattern[current_pattern][pattern_index]:
		key_to_play = direction_map[song_pattern[current_pattern][pattern_index]]
	
	if key_to_play:
		var loc = $Pivot/Node2D/Dropoff.global_position
		var new_key = key.instance()
		new_key.set_key = key_to_play
		# set key according to pattern
		# increment current pattern key
		new_key.global_position = loc
		add_child(new_key)
	
	
			
	pattern_index = wrapi(pattern_index + 1, 0, song_pattern[current_pattern].size())	
	
	#current_pattern_key = wrapi(current_pattern_key + 1, 0, song_pattern[beat_stops[current_pattern]].size())
	

func on_measure(pos):
	# load notes for this measure
	pass

func _on_Okay_area_entered(area):
	if area is Key:
		colliding_key = area
		colliding_key.modulate = Color.red
		okay = true
		
func _on_Okay_area_exited(area):
	area.modulate = Color.white
	if area is Key:
		colliding_key = null
		okay = false
		if area.is_ready:
			area.destroy(0)

func _on_Good_area_entered(area):
	if area is Key:
		good = true
		area.modulate = Color.green

func _on_Good_area_exited(area):
	if area is Key:
		good = false


func _on_Perfect_area_entered(area):
	if area is Key:
		perfect = true
		area.modulate = Color.blueviolet

func _on_Perfect_area_exited(area):
	if area is Key:
		perfect = false

func _reset():
	okay = false
	good = false
	perfect = false
	colliding_key = null


func _on_Area2D_area_entered(area):
	safe_to_drop = false


func _on_Area2D_area_exited(area):
	safe_to_drop = true
