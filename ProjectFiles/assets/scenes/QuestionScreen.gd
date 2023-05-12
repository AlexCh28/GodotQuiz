extends Control


var json_questions: Array = []
var questions_amout = 0
var current_question = 0 setget set_current_question


func _ready():
	$SummaryButton.disabled = true
	$SummaryButton.visible = false
	
	var file = File.new()
	file.open("res://assets/json/questions.json", File.READ)
	
	var content = file.get_as_text()
	
	json_questions = parse_json(content)
	
	questions_amout = len(json_questions)
	print(questions_amout)
	show_question(current_question)


func _on_NextButton_button_up():
	if current_question+1 < questions_amout:
		self.current_question += 1
		if current_question >= questions_amout-1:
			$NextButton.disabled = true
			$NextButton.visible = false
			
			$SummaryButton.disabled = false
			$SummaryButton.visible = true


func set_current_question(var value):
	current_question = value
	show_question(current_question)


func show_question(var index):
	$BackgroundTexture.texture = load(json_questions[index]["background"])
	$QuestionLabel.text = json_questions[index]["question"]
	$Answers.clear()
	for answer in json_questions[index]["answers"]:
		$Answers.add_item(answer["text"])
