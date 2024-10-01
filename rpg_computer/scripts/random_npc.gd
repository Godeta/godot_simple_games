extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT

var is_roaming = true
var is_chatting = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	
func _process(delta):
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

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
