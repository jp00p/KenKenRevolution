extends Node2D

export var level := 1

func _ready():
	$GetScores.request("https://jp00p.com/kkr/get_high_score.php?level=1")

func _on_GetScores_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
