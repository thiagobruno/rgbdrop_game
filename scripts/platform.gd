extends Node2D

var direction = 'left'
var _vel = 100

func _ready():
	randomize()
	_vel = rand_range(100, 300)
	print('estamos na area')
	set_process(true)
	
func setDirection(dir):
	self['direction'] = dir
	
func _process(delta):
	if direction == 'left':
		set_pos(get_pos() - Vector2(_vel * delta, 0))
		if get_pos().x < -1000:
			queue_free()
				
	if direction == 'right':
		set_pos(get_pos() + Vector2(_vel * delta, 0))
		if get_pos().x > 1000:
			queue_free()
	
	
