extends Node2D

onready var floating_text := preload("res://FloatingText.tscn")

var okay := false
var good := false
var perfect := false
var current_note = null
var thump = 1

export var input := ""

func _ready():
	Globals.connect("beat", self, "on_beat")
	
func _process(delta):
	if thump > 1:
		$Sprite.scale = Vector2(thump,thump)
		thump = max(thump - delta, 1)

func _unhandled_input(event):
	if event.is_action(input):
		var ft_text = "miss"
		if event.is_action_pressed(input, false):
			if current_note != null:
				Globals.combo += 1
				if perfect:
					current_note.destroy(10)
					ft_text = "perfect!"
				elif good:
					current_note.destroy(5)
					ft_text = "good!"
				elif okay:
					current_note.destroy(2)
					ft_text = "okay"
				_reset()
			else:
				ft_text = "miss"
				Globals.combo = 0
			spawn_floating_text(ft_text)
			
		
		if event.is_action_pressed(input):
			modulate = Globals.green
		elif event.is_action_released(input):
			modulate = Color.white
		

func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false
	
func spawn_floating_text(txt):
	var ft = floating_text.instance()
	ft.text = txt
	ft.global_position = global_position
	ft.global_position.y -= 48
	ft.global_position.x -= 24
	get_tree().get_root().add_child(ft)
	
	
func _on_Okay_area_entered(area):
	if area is Note:
		okay = true
		current_note = area

func _on_Okay_area_exited(area):
	if area is Note:
		okay = false
		current_note = null
		

func _on_Good_area_entered(area):
	if area is Note:
		good = true

func _on_Good_area_exited(area):
	if area is Note:
		good = false

func _on_Perfect_area_entered(area):
	if area is Note:
		perfect = true

func _on_Perfect_area_exited(area):
	if area is Note:
		perfect = false


func _on_Exit_area_exited(area):
	if area is Note:
		_reset()
		area.destroy(0)
		Globals.combo = 0
		spawn_floating_text("miss")

func on_beat(_pos):
	thump = 1.1
	pass
