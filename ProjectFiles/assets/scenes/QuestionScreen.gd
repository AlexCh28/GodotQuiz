extends Control

onready var summary_button = $CheckResult/SummaryButton
onready var next_button = $CheckResult/NextButton
onready var background_texture = $BackgroundTexture
onready var question_label = $QuestionLabel
onready var answers_panel = $Answers
onready var check_result_panel = $CheckResult
onready var result_label = $CheckResult/ResultLabel
onready var check_button= $CheckButton

var json_questions: Array = []
var answers_selected: Array = []
var questions_amout = 0
var current_question = 0 setget set_current_question


func _ready():
	toggle_button(summary_button, false)
	
	var file = File.new()
	file.open("res://assets/json/questions.json", File.READ)
	json_questions = parse_json(file.get_as_text())
	file.close()
	
	questions_amout = len(json_questions)
	PlayerData.amount_of_questions = questions_amout
	
	show_question(current_question)


func _input(event):
	if (event is InputEventMouseButton):
		if (event.pressed):
			event.control = true


func _on_NextButton_button_up():
	if current_question+1 < questions_amout:
		self.current_question += 1
		if current_question >= questions_amout-1:
			toggle_button(next_button, false)
			toggle_button(summary_button, true)
		check_result_panel.visible = false


func _on_Answers_multi_selected(index, selected):
	if selected:
		answers_selected.append(index)
	elif !selected:
		answers_selected.erase(index)


func _on_CheckButton_button_up():
	var correct = check_answers()
	check_result_panel.visible = true
	if correct:
		result_label.text = "Верно"
		PlayerData.amout_of_right_answers += 1
	elif !correct:
		result_label.text = "Неверно"


func set_current_question(value):
	current_question = value
	show_question(current_question)


func toggle_button(button, value):
	button.disabled = !value
	button.visible = value


func check_answers():
	var result = true
	
	var amount_of_right_answers = 0
	for answer in json_questions[current_question]["answers"]:
		if answer["correct"]:
			amount_of_right_answers += 1
	
	if len(answers_selected)==0:
		result = false
	else:
		for answer_index in answers_selected:
			result = result and json_questions[current_question]["answers"][answer_index]["correct"]
	return result and len(answers_selected)==amount_of_right_answers


func show_question(index):
	background_texture.texture = load(json_questions[index]["background"])
	question_label.text = json_questions[index]["question"]
	answers_selected.clear()
	answers_panel.clear()
	for answer in json_questions[index]["answers"]:
		answers_panel.add_item(answer["text"])
