extends Node2D

var spin = false

func _process(delta):
	if spin:
		$Pivot.rotation_degrees += 600 * delta
		$Pivot.scale *= 1.005


func _on_Level1_pressed():
	spin = true
	Globals.level = 1
	get_tree().change_scene("res://Game.tscn")


func _on_Level2_pressed():
	spin = true
	Globals.level = 2
	get_tree().change_scene("res://Game.tscn")


func _on_Level3_pressed():
	spin = true
	Globals.level = 3
	get_tree().change_scene("res://Game.tscn")


func _on_Scores_pressed():
	spin = true
