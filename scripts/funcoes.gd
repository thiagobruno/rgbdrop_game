extends Node2D

var vibrate
#onready var googleService = Globals.get_singleton("GooglePlay")
var googleService = null
var data = OS.get_date()
var savegame = File.new()
var save_path = "user://dropColors1.save"
var save_data

var arrConquistas = {}

var arrLevels = [
	{
		"level" : 1,
		"googleLeaderboardId" : "",
		"googleLeaderboardStr" : "",
		"custo" : 0,
		"liberado" : 1,
		"nome" : "LEVEL_1",
	}
]

var save_model = {
	"jsonVersion": "0.0.0.1",
	"nomeJogador": "", 
	"_modificado": false,
	"totalMoedasData": "",
	"totalMoedas": 0,
	"totalMoedasHoje": 0
}

var loadedData
var tempData

var JsonVersaoAtual = "0.0.0.1"
var JsonVersao



func _ready():
	
	## Conexão com Google Service
	#if(Globals.has_singleton("GooglePlay") && OS.get_name()=='Android'):
	#	googleService.init(get_instance_ID());
	#	googleService.login();

	#if(Globals.has_singleton("GodotVibrate") && OS.get_name()=='Android'):
 		#vibrate = Globals.get_singleton("GodotVibrate")

	
	if not savegame.file_exists(save_path):
		newFile(save_path, save_model)
		updateSavedData()
		fixJson()
	else:
		loadSavedGame()
		JsonVersao = readData("jsonVersion")
		if str(JsonVersao) == '0':
			var savegameTMP = File.new()
			savegameTMP.open(save_path, File.READ)
			var save_data1 = savegameTMP.get_var() #get the value
			save_data = save_data1
			savegameTMP.close() #close the file
			onlySaveData()
		
		if str(JsonVersao) != str(JsonVersaoAtual):
			# Se a versão estiver diferente, aplica atualizações no arquivo do usuário
			updateSavedData()
			fixJson()

	# Reseta a quantidade de moedas coletadas hoje se mudou o dia
	var keyData = str(readData('totalMoedasData'))
	var keyHoje = str(data['day'],'_',data['month'],'_',data['year'])
	
	if keyData != keyHoje:
		saveData('totalMoedasData', keyHoje)
		saveData('totalMoedasHoje', 0)

func checkConquista(_nome):
	var conquistas = readData("conquistas")
	var ret = false
	
	if conquistas!=null:
		if conquistas.has(_nome):
			ret = (conquistas[_nome] == true)
	
	return ret
	
func saveConquista(_nome, _valor):
	save_data["conquistas"][_nome] = _valor
	onlySaveData()

func isLoggedGoogleService():
	return Globals.has_singleton("GooglePlay") && OS.get_name()=='Android' && googleService

func _receive_message(from, key, data):
	pass
	#if from == "GooglePlay":
		#print("Key: ", key, " Data: ", data)

func getSaveData():
	return self.loadSaveGame()

func fixJson():
	var conquistas = readData("conquistas")
	if conquistas == 0:
		saveData("conquistas", arrConquistas)
		
	var levels = readData("levels")
	if levels == 0:
		saveData("levels", arrLevels)
	
	if levels != 0:
		var idx=0
		for l in levels:
			#bkp dados do usuario
			var liberado = l["liberado"]
			
			var baseL = arrLevels[idx]
			save_data["levels"][idx] = baseL
			
			#restore bkp dados do usuario
			saveDataArray("levels", idx, "liberado", liberado)
			idx+=1

		## Informações do level no google leaderboards
	#LEVEL1
	saveDataArray("levels", 1-1, "googleLeaderboardId", "")
	saveDataArray("levels", 1-1, "googleLeaderboardStr", "")

	#LEVEL3


func updateSavedData():
	#salva a versão atual
	saveData("jsonVersion", JsonVersaoAtual)

func newFile(_path, _data):
	save_data = _data
	savegame.open_encrypted_with_pass(_path, File.WRITE, OS.get_unique_ID())
	savegame.store_var(_data)
	savegame.close()

func loadSavedGame():
	# carrega o arquivo inteiro salvo
	savegame.open_encrypted_with_pass(save_path, File.READ, OS.get_unique_ID())
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	return save_data

func readData(campo):
	var ret = 0
	if save_data != null:
		if save_data.has(campo):
			ret = save_data[campo] #return the value
	return ret
	
func readDataArray(arrayName, arrayNum, key):
	var level
	var ret = 0
	if save_data!=null:
		if save_data.has(arrayName):
			level = save_data[arrayName]
			if level!=null:
				var lk = level[arrayNum]
				if lk.has(key):
					ret = lk[key]
	return ret
	
func onlySaveData():
	# somente salva as informações
	savegame.open_encrypted_with_pass(save_path, File.WRITE, OS.get_unique_ID())
	savegame.store_var(save_data) #store the data
	savegame.close() # close the file

func saveData(campo, valor):
	if save_data!=null:
		save_data[campo] = valor

func saveDataArray(arrayName, arrayNum, key, value):
	if save_data != null:
		if save_data.has(arrayName):
			save_data[arrayName][arrayNum][key] = value

func submitLeaderboard(leaderboard_id, value):
	if false:
		if isLoggedGoogleService() && leaderboard_id!='':
			googleService.submit_leaderboard(int(value), str(leaderboard_id));

func unlockAchievement(achievement_id, achievement_str):
	if false:
		if isLoggedGoogleService() && achievement_id!='':
			if !checkConquista(achievement_str):
				googleService.unlock_achievement(achievement_id);
				saveConquista(achievement_str, true)

func showLeaderboards(lId):
	if isLoggedGoogleService():
		if lId!='':
			googleService.show_leaderboards(lId);
		else:
			googleService.show_leaderboards();
	
func showAchievements():
	if isLoggedGoogleService():
		googleService.show_achievements();
	
func desbloqueiaConquistas():
	#print('verificando conquistas...')
	var coletadoHoje = int(readData('totalMoedasHoje'))
	var coletadoTotal = int(readData('totalMoedas'))

	## moedas
	if coletadoHoje >= 100:
		var achievement_id = ""
		var achievement_str = ""
		unlockAchievement(achievement_id, achievement_str)
		#print("desbloqueia 100 primeiras moedas")
		
	if coletadoHoje >= 500:
		var achievement_id = ""
		var achievement_str = ""
		unlockAchievement(achievement_id, achievement_str)
		#print("desbloqueia 500 primeiras moedas")

	if coletadoHoje >= 1000:
		var achievement_id = ""
		var achievement_str = ""
		unlockAchievement(achievement_id, achievement_str)
		#print("desbloqueia 1000 moedas coletadas hoje")

func goVibrate(_ms):
	pass
	#if(Globals.has_singleton("GodotVibrate") && OS.get_name()=='Android') && vibrate:
		#vibrate.doVibrate(_ms) # milliseconds

func calculaValor(arrayName, value, _op):
	var v = int(readData(arrayName))
	var novoValor = 0
	
	if _op == '+':
		novoValor = v+value
	elif _op == '-':
		if v >= value:
			novoValor = v-value
	
	# Total de moedas
	var googleLeaderboardId= ""
	funcoes.submitLeaderboard(googleLeaderboardId, novoValor)
	saveData(arrayName, novoValor)

func _on_DesbloqueiaConquistas_timeout():
	self.desbloqueiaConquistas()

func _on_SaveUserData_timeout():
	onlySaveData()
