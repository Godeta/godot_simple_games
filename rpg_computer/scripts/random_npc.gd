extends CharacterBody2D

const speed = 15
var current_state = IDLE

var dir = Vector2.RIGHT

var is_roaming = true
var is_chatting = false
var player_in_area = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	
func _process(delta):
	if player_in_area:
		#print("Vas y PARLE")
		if Input.is_action_just_pressed("dialogic_default_action"):
			#print(" O K OK")
			run_dialogue()
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:	
		if dir.x == -1:
			$AnimatedSprite2D.play("w-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("e-walk")
		if dir.y == -1:
			$AnimatedSprite2D.play("n-walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("s-walk")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
			

func run_dialogue():
	is_chatting = true
	is_roaming = false
	$Dialogue.start()

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = IDLE #choose([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished():
	is_chatting = false
	is_roaming = true

func _on_chat_detection_zone_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		#print("dedans")


func _on_chat_detection_zone_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		#print("dehors")
