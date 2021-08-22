extends Node2D

onready var star1 := preload("res://assets/particles/particleSmallStar.png")
onready var star2 := preload("res://assets/particles/particleStar.png")
onready var star3 := preload("res://assets/particles/particleCartoonStar.png")
var stars := []

func _ready():
	randomize()
	stars = [star1, star2, star3]
	var random_color = Globals.pick_random_color()
	$Sprite.texture = stars[randi()%stars.size()]
	$Sprite.modulate = random_color
