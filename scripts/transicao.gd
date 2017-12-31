extends CanvasLayer

var _continue = false
var _morreu = false
var _modalAberto = false
var custoMoeda = 15
var path = ""
var cenaAtual = ""

func fade_to(scn_path):
	self.path = scn_path
	self.cenaAtual = get_tree().get_current_scene()
	get_node("anim").play("fade")

func change_scene():
	if path != "":
		get_tree().change_scene(path)

	if cenaAtual:
		cenaAtual.queue_free()
	
func pause_game():
	if !_modalAberto:
		_modalAberto = true
		var _totalMorreu = int(funcoes.readData('totalMorreu'))
		
		get_tree().set_pause(true)
		get_node("Control/Popup").show()
		get_node("Control/Popup/AnimationPlayer/ModalPause").show()
		get_node("Control/Popup/AnimationPlayer").play("modalAnimIn")
	
func resume_game():
	get_node("Control/Popup/AnimationPlayer").play("modalAnimOut")

func resume_game_track():
	get_node("Control/Popup/AnimationPlayer/ModalPause").hide()
	get_node("Control/Popup").hide()
	get_tree().set_pause(false)
	_modalAberto = false
	
func _on_TouchScreenButton_pressed():
	self._continue = false
	resume_game()
	
func loadBase():
	transicao.fade_to("res://scenes/base.tscn") 

func _on_TouchScreenButton_2_pressed():
	sair()
	
func restart():
	self._continue = false
	self.custoMoeda = 15
	#var cenaLevel = get_tree().get_current_scene()
	#cenaLevel.setStatusJogo('_morreu', true)
	#cenaLevel.get_node("obstaculos/Obstaculos").kill()
	#resume_game()
	#change_scene()
	#loadBase()
	if path != "":
		transicao.fade_to(path) 
	
	resume_game()
	
	
func sair():
	self._continue = false
	self.custoMoeda = 15
	#var cenaLevel = get_tree().get_current_scene()
	#cenaLevel.setVar('_morreu', true)
	#cenaLevel.get_node("obstaculos/Obstaculos").kill()
	resume_game()
	loadBase()

func _on_TouchRestart_pressed():
	restart()

func _on_ButtonResumo_pressed():
	self._continue = false
	resume_game()

func _on_ButtonContinue_pressed():
	var totalMoedas = int(funcoes.readData('totalMoedas'))
	if totalMoedas >= self.custoMoeda:
		self._continue = true
		resume_game()


func setVar(_var, _num):
	self[_var] = _num
	funcoes.saveData(_var, _num)
	
func getVar(_var):
	return self[_var]
