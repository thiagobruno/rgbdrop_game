extends Node2D

var points = 0
var directions = ['right', 'left']
var colors = ['green', 'red', 'blue']
var alturas = [500,800,1100,1400]
var alturaOld
var dOld
var colorOld
var highscore = 0
onready var platform = preload("res://scenes/platform.tscn")
onready var ball = preload("res://scenes/ball.tscn")

func _ready():
	randomize()
	highscore = funcoes.readData("points")

func _on_btnPause_pressed():
	transicao.pause_game()


func _on_geraPlataform_timeout():
	var largura = rand_range(1,3)
	if dOld == 0:
		dOld = 1
	else:
		dOld = 0
	var d = directions[dOld]
	
	if alturaOld == 0:
		alturaOld = 1
	elif alturaOld == 1:
		alturaOld = 2
	elif alturaOld == 2:
		alturaOld = 3
	else:
		alturaOld = 0
		
	var altura = alturas[alturaOld]
				
	var newPlatform = platform.instance()
	newPlatform.setDirection(d)
	if d == 'left':
		newPlatform.set_pos(Vector2(1000, altura))
		newPlatform.set_rot(0.09)
	elif d == 'right':
		newPlatform.set_pos(Vector2(-1000, altura))
		newPlatform.set_rot(-0.09)
	
	newPlatform.set_scale(Vector2(rand_range(1,3), 1))
	get_node("platforms").add_child(newPlatform)


func _on_geraBalls_timeout():
	genBall()
	
func genBall():
	if colorOld == 0:
		colorOld = 1
	elif colorOld == 1:
		colorOld = 2
	else:
		colorOld = 0
	
	var newBall = ball.instance()
	newBall.get_node("color").set_animation(colors[colorOld])
	get_node("balls").add_child(newBall)
	


func _on_Area2D_body_enter( body ):
	body.queue_free()
	if points > 0:
		points -= 1
		get_node("outSound").play()


func _on_colorR_body_enter( body ):
	if body.get_node("color").get_animation() == 'red':
		points += 5
		get_node("bucketSound").play()
	else:
		if points > 0:
			points -= 1
	body.queue_free()

func _on_colorG_body_enter( body ):
	if body.get_node("color").get_animation() == 'green':
		points += 5
		get_node("bucketSound").play()
	else:
		if points > 0:
			points -= 1
	body.queue_free()

func _on_colorB_body_enter( body ):
	if body.get_node("color").get_animation() == 'blue':
		points += 5
		get_node("bucketSound").play()
	else:
		if points > 0:
			points -= 1
	body.queue_free()

func _on_atualizaPlacar_timeout():
	if points > highscore:
		funcoes.saveData("points", points)

	get_node("Node2D/Control/placar").set_text(str(points))
