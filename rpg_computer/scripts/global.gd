extends Node
var player_current_attack = false
var current_scene = "world" #word cliff side
var transition_scene = false

var player_exit_cliffside_posx = 396
var player_exit_cliffside_posy = -118
var player_start_posx = 0
var player_start_posy = -40

var first_load = true

func finishChangescene():
	if transition_scene == true:
		if current_scene == "world":
			current_scene = "cliffside"
		else:
			current_scene = "world"
	transition_scene = false
	print(current_scene)
