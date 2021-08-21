extends Node2D

class_name Key

var is_ready = false
var directions := ["up", "right", "down", "left"]
var keys := [KEY_UP, KEY_RIGHT, KEY_DOWN, KEY_LEFT]

var rotations := [0,90,180,270]
var this_direction := ""
var set_key = null
var highlow
var key_required
var beat
var pulse_on = 0
var dead = false

signal destroyed(points)

func _ready():
	randomize()
	Globals.connect("beat", self, "on_beat")
	highlow = randi() % 2 # react to high or low notes?
	beat = randi() % 4 + 1
	$InitParticles.emitting = true
	var pick
	pulse_on = randi() % 4
	
	if !set_key:
		pick = randi() % directions.size()
	else:
		pick = set_key
		
	this_direction = directions[pick]  # which direction
	key_required = keys[pick]  # which key
	$Arrow.rotation_degrees = rotations[pick]
		
	
func _process(delta):
	if dead:
		rotation += 10 * delta

func destroy(points):
	dead = true
	yield(get_tree().create_timer(0.66), "timeout")
	emit_signal("destroyed", points)
	queue_free()
		
func on_beat(pos):
	var beat  = pos % 4
	if !$AnimationPlayer.is_playing() and beat == pulse_on:
		$AnimationPlayer.play("pulse")
		$BeatParticles.set_emitting(true)

func _on_Iframes_timeout():
	# don't let player immediately press the key
	is_ready = true
	set_deferred("monitoring", true)
