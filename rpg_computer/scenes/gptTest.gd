extends Node

var api_key : String = ""
var url : String = "https://api.openai.com/v1/chat/completions"
var temperature : float = 0.5 #consistency
var max_tokens : int = 1024 #max memory
var headers = ["Content-type: application/json", "Authorization: Bearer "+ api_key] #format of data send and get
var model : String = "gpt-4o-2024-08-06" #"gpt-3.5-turbo"
var messages = []
var request : HTTPRequest
var latest_message : String = ""  # Store the latest response message

# Called when the node enters the scene tree for the first time.
func _ready():
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed) #send to the signal
	#dialogue_request("Tell me about the abbaye of Déols in France")
	
func dialogue_request (player_dialogue):
	messages.append({
		"role": "user",
		"content": player_dialogue
		}) #add the object with the user dialogue
	messages.append({
		"role": "system",
		"content": "Always give short answers below 80 characters. You are a French monk living in an abbaye around the year 900 AD. You speak only in French, with the wisdom, humility, and faith of a monk from that era. Your speech is formal and respectful, reflecting the knowledge of religious texts, daily monastic life, and the values of devotion, prayer, and simplicity."
		})
		#turn all objects in json format
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	if send_request != OK:
		print("There was an error !")
	
func _on_request_completed (result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	#print(response)
	latest_message = response["choices"][0]["message"]["content"]
	print(latest_message)

# Function to retrieve the latest answer
func getAnswer() -> String:
	return latest_message

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
