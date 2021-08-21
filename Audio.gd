extends Node2D

var min_freq := 20
var max_freq := 20000
var definition := 20
var histogram := []
var mag
var accel := 20
var total_w := 500
var total_h := 500

var min_db := -55
var max_db := -16

var rotation_speed = -1
var time_delay

onready var spectrum := AudioServer.get_bus_effect_instance(0, 0)
var textureimage := Image.new()
var texture := ImageTexture.new()

func _ready():
	
	textureimage.load("res://assets/particles/particleCartoonStar.png")
	texture.create_from_image(textureimage)
	
	for i in range(definition):
		histogram.append(0) # saving values in this array for visualization later

func _process(delta):
	
	rotation += rotation_speed * delta
	
	var freq = min_freq
	var interval = (max_freq - min_freq) / definition
	
	for i in range(definition):
		
		var freq_low = float(freq - min_freq) / float(max_freq - min_freq)
		freq_low *= freq_low # square
		freq_low = lerp(min_freq, max_freq, freq_low)
		
		freq += interval
		
		var freq_high = float(freq - min_freq) / float(max_freq - min_freq)
		freq_high *= freq_high # square
		freq_high = lerp(min_freq, max_freq, freq_high)
		
		
		mag = spectrum.get_magnitude_for_frequency_range(freq_low, freq_high)
		mag = linear2db(mag.length())
		mag = (mag - min_db) / (max_db - min_db)
		
		mag += 0.3 * (freq - min_freq) / (max_freq - min_freq)
		mag = clamp(mag, 0.05, 1)
		
		histogram[i] = lerp(histogram[i], mag, accel * delta)
	Globals.music_notes = histogram
	update()
	
func _draw():
	var draw_pos = Vector2(0, 0)
	var w_interval = total_w / definition
	
	#draw_line(Vector2(0, -total_h), Vector2(total_w, -total_h), Color.crimson, 2.0, true)

	#for i in range(definition):
	#	draw_line(draw_pos, draw_pos + Vector2(0, -histogram[i] * total_h), Color.crimson, 4.0, true)
	#	draw_pos.x += w_interval
	
	var angle = PI
	var angle_interval = 2 * PI / definition
	var radius = 120
	var length = 66
	
	for i in range(definition):
		var normal = Vector2(0, -1).rotated(angle)
		var start_pos = normal * radius
		var end_pos = normal * (radius + histogram[i] * length)
		draw_line(start_pos, end_pos, Color.white, 0.5, true)
		draw_texture(texture, Vector2(end_pos.x-5, end_pos.y-5))
		#draw_texture_rect(texture, Rect2(start_pos, end_pos), true)
		angle += angle_interval
	
