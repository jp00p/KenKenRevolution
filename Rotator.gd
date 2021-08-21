extends Node2D

var max_keys := 25
var total_keys := 0
onready var rotation_speed := 1.2
var indicator_colliding := false
var colliding_key = null
var perfect := false
var good := false
var okay := false

var safe_to_drop := true

onready var key := preload("res://Key.tscn")
onready var floating_text := preload("res://FloatingText.tscn")
onready var indicator := $Pivot/Node2D/Indicator

signal rotator_beat

func _ready():
	randomize()
	Globals.connect("beat", self, "on_beat")
	Globals.connect("measure", self, "on_measure")

func _process(delta):
	$Pivot/Node2D.rotation += rotation_speed * delta
	$Pivot/Node2D/Indicator.rotation += rotation_speed * delta
	$Label.text = str(okay)


func _unhandled_input(event):
	
	if colliding_key == null or !colliding_key.is_ready:
		return
	
	var rank = ""
	
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(colliding_key.key_required):
			if perfect:
				rank = "Perfect!"
				colliding_key.modulate = Color.blue
			elif good:
				rank = "Good!"
				colliding_key.modulate = Color.green
			elif okay:
				rank = "Okay!"
				colliding_key.modulate = Color.yellow
		else:
			rank = "Miss!"
			
		var ft = floating_text.instance()
		ft.text = rank
		ft.position = indicator.global_position
		add_child(ft)
		colliding_key.destroy(10)
		_reset()

func on_beat(pos):
	if not safe_to_drop:
		return
	if total_keys < max_keys and pos % 2 == 0:
		var loc = $Pivot/Node2D/Dropoff.global_position
		var new_key = key.instance()
		new_key.global_position = loc
		add_child(new_key)
		total_keys += 1

func on_measure(pos):
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

func _on_Good_area_entered(area):
	if area is Key:
		good = true

func _on_Good_area_exited(area):
	if area is Key:
		good = false

func _on_Perfect_area_entered(area):
	if area is Key:
		perfect = true

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
