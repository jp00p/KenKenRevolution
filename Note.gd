extends Area2D

class_name Note

signal destroyed(points)

var directions := ["up", "right", "down", "left"]
var rotations := [0, 90, 180, 270] 
var speeds := [Vector2(0,-1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
var direction := 0
var speed = Vector2.ZERO

func _ready():
	self.connect("destroyed", Globals, "note_destroyed")
	rotation_degrees = rotations[direction]
	$Sprite/CPUParticles2D.angle = -rotations[direction]
	self.modulate = Globals.foreground_colors[randi()%Globals.foreground_colors.size()]

func _process(delta):
	global_position += speeds[direction] * 300 * delta

func destroy(points):
	emit_signal("destroyed", points)
	queue_free()
