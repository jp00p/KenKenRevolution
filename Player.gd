extends Node2D

func _ready():
	Globals.connect("beat", self, "on_beat")

func _process(delta):
	$Pivot.rotation_degrees += 50 * delta
	$Pivot2.rotation_degrees += 50 * delta
	
func on_beat(_pos):
	$Pivot/Character/Particle1.modulate = Globals.pick_random_color()
	$Pivot2/Character/Particle1.modulate = Globals.pick_random_color()
