extends CharacterBody2D
const SPEED = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		velocity.x = SPEED
		velocity.y = 0
		play_animation(1)
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		velocity.x = -SPEED
		velocity.y = 0
		play_animation(1)
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		velocity.x = 0
		velocity.y = SPEED
		play_animation(1)
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		velocity.x = 0
		velocity.y = -SPEED
		play_animation(1)
	else:
		velocity.x = 0
		velocity.y = 0
		play_animation(0)
		
	move_and_slide()
	
func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir =="right":
		anim.flip_h = false
		if movement==1:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	if dir =="left":
		anim.flip_h = true
		if movement==1:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	if dir =="down":
		anim.flip_h = false
		if movement==1:
			anim.play("front_walk")
		else:
			anim.play("front_idle")
	if dir =="up":
		anim.flip_h = false
		if movement==1:
			anim.play("back_walk")
		else:
			anim.play("back_idle")
