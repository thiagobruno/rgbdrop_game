extends Node2D

var points = 0
var colors = ['red', 'green', 'blue']
var colorOld
onready var ball = preload("res://scenes/ball.tscn")

func _ready():
	points = funcoes.readData("points")
	get_node("btnJogar/Control/highscore").set_text(str(points))

func _on_btn1_pressed():
	transicao.fade_to(str("res://scenes/level1.tscn")) 

func genBall():
	if colorOld == 0:
		colorOld = 1
	elif colorOld == 1:
		colorOld = 2
	else:
		colorOld = 0
	
	var newBall = ball.instance()
	newBall.get_node("color").set_animation(colors[colorOld])
	newBall.autoKill()
	get_node("ballsBase/balls").add_child(newBall)

func _on_Timer_timeout():
	genBall()
