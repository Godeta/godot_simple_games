extends Area2D
@onready var timer = $Timer
@onready var death = $death


func _on_body_entered(body):
	print("You died")
	death.play()
	Music.stop()
	Engine.time_scale = 0.15
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	Music.play()
	get_tree().reload_current_scene()
