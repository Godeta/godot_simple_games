extends Control

@export_file("*.json") var d_file

signal dialogue_finished

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	$NinePatchRect2.visible = false;
	$LineEdit.visible = false  # Hide LineEdit initially
	#start()

func start():
	print("DEBUT")
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	print("Chargement du dialogue !!!")
	var file = FileAccess.open("res://dialogue/npc_dialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("dialogic_default_action"):
		next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		show_input_field()  # Show LineEdit when dialogue is finished
		return
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']

# Show the LineEdit for user input after dialogue ends
func show_input_field():
	$LineEdit.visible = true
	$LineEdit.grab_focus()  # Focus the LineEdit so user can type

func _on_line_edit_text_changed(new_text):
	#print("User input:", new_text)
	if(new_text.contains("\n")):
		$LineEdit.visible = false  # Hide the input field after submission
		$LineEdit.clear()  # Clear the text for future input


func _on_line_edit_text_submitted(new_text):
	$NinePatchRect2.visible = false;
	print("User input:", new_text)
	$LineEdit.visible = false  # Hide the input field after submission
	$LineEdit.clear()  # Clear the text for future input
	$Timer.start()
#	gpt call 
	$GPT_call.dialogue_request(new_text)
	#d_active = false
	#$NinePatchRect.visible = false

func show_ai_answer(text):
	$NinePatchRect2.visible = true
	$NinePatchRect2/Name.text = "npc"
	$NinePatchRect2/Text.text = text
	$Timer2.start()


func _on_timer_timeout():
# afficher résultat
	var response = $GPT_call.getAnswer()
	show_ai_answer(response)


func _on_timer_2_timeout():
	$NinePatchRect2.visible = false
