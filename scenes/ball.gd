extends RigidBody2D

var linearVelocityModule = 0

func _ready():
	randomize()
	set_process_input(true)
	set_process(true)
	
func _process(delta):
	if OS.get_name() == 'Android' || OS.get_name() == 'iOS':
		var acel = Input.get_accelerometer().x * 400
		if acel < 0:
	        move_right(acel)
		else:
	        move_left(acel)


func _input(event):
	if event.is_action_pressed("touch"):
		impulso()
		self.linearVelocityModule = 0
		
	if event.is_action_pressed("ui_left"):
		move_left(-150)
		
	if event.is_action_pressed("ui_right"):
		move_right(150)

func impulso():
	var anglePlayerRot = get_rot()
	var localLinearVelocityX = linearVelocityModule * cos (anglePlayerRot)
	apply_impulse(Vector2(0,0), Vector2(localLinearVelocityX, 0))

func move_left(x):
	self.linearVelocityModule = x * -1
	impulso()

func move_right(x):
	self.linearVelocityModule = x * -1
	impulso()

func autoKill():
	get_node("autoKill").set_wait_time(rand_range(5,10))
	get_node("autoKill").start()
	
func kill():
	queue_free()


func _on_Timer_timeout():
	kill()
