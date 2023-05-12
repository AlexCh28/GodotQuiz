extends Control

onready var result_label = $ResultLabel

func _ready():
	result_label.text = result_label.text % [PlayerData.amout_of_right_answers, PlayerData.amount_of_questions]
	PlayerData.amount_of_questions = 0
	PlayerData.amout_of_right_answers = 0
