extends CharacterBody2D
const SPEED = 100
const SPRINT_MULTIPLIER = 1.5
var current_dir = "none"
var enemy_inattack_range = false
var enemy_attack_cooldwon = true
var health = 100
var player_alive = true
var attack_ip = false

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	if health <=0:
		player_alive = false #endscreen or respawn or menu...
		print("dead")
		health=0
		self.queue_free()

func player_movement(delta):
	# Reset velocity at the start of each frame
	velocity = Vector2.ZERO
	var is_moving = false
	var is_sprinting = Input.is_action_pressed("shift")

	# Check for horizontal movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		current_dir = "right"
		is_moving = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		current_dir = "left"
		is_moving = true

	# Check for vertical movement
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED
		current_dir = "down"
		is_moving = true
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED
		current_dir = "up"
		is_moving = true

	# Normalize diagonal movement to maintain consistent speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	# Apply sprint multiplier if sprinting
	if is_sprinting:
		velocity *= SPRINT_MULTIPLIER

	# Play appropriate animation
	play_animation(1 if is_moving else 0, is_sprinting)
		
	move_and_slide()
	
func play_animation(movement, is_sprinting):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	# Simplify animation logic
	match dir:
		"right", "left":
			anim.flip_h = (dir == "left")
			if movement == 1:
				anim.play("side_walk")
			elif attack_ip == false:
				anim.play("side_idle")
		"down":
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif attack_ip == false:
				anim.play("front_idle")
		"up":
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif attack_ip == false:
				anim.play("back_idle")
	
	# Adjust animation speed for sprinting
	if is_sprinting and movement == 1:
		anim.speed_scale = SPRINT_MULTIPLIER
	else:
		anim.speed_scale = 1.0

# Improvements:
# 1. Allow diagonal movement by checking horizontal and vertical inputs separately
# 2. Normalize velocity for consistent speed in all directions
# 3. Simplified animation logic using match statement
# 4. Use Vector2 for velocity calculations
# 5. Removed redundant velocity assignments
# 6. Added is_moving flag to determine if any movement key is pressed
# 7. Added sprinting functionality when shift is pressed
# 8. Adjusted animation speed for sprinting

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if(body.has_method("enemy")):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if(body.has_method("enemy")):
		enemy_inattack_range = false
		
func enemy_attack():
	if (enemy_inattack_range and enemy_attack_cooldwon == true):
		health = health - 20
		enemy_attack_cooldwon = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldwon=true

func attack():
	var anim = $AnimatedSprite2D
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip=true
		# Simplify animation logic
		match dir:
			"right", "left":
				anim.flip_h = (dir == "left")
				anim.play("side_attack")
				$deal_attack_timer.start()
			"down":
				anim.flip_h = false
				anim.play("front_attack")
				$deal_attack_timer.start()
			"up":
				anim.flip_h = false
				anim.play("back_attack")
				$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false;
	attack_ip = false # Replace with function body.

func current_camera():
	if global.current_scene =="world":
		$Camera2D.enabled =true
		$cliffSideCamera.enabled = false
	elif global.current_scene =="cliffside":
		$Camera2D.enabled= false
		$cliffSideCamera.enabled = true
		print("test")
