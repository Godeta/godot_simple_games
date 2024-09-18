extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.first_load:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	changeScene()

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true



func changeScene():
	if global.transition_scene == true :
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
			global.first_load = false
			global.finishChangescene()
