extends Node

var score =0
@onready var score_label = $scoreLabel

func add_point():
	score+=1
	print(score)
	score_label.text = "Ton score est " + str(score) + " coins."
