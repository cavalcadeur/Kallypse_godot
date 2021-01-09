extends Node

export (PackedScene) var Framboise
export (PackedScene) var Boss_Lapin
export (PackedScene) var Tuto_fleches
export (PackedScene) var Tuto_Roulade
export (PackedScene) var Exclamation
export (PackedScene) var Photo
export (PackedScene) var Shooter

var scene = 1
var dialogue = 0
var nTexte = 0
var texte
var data
var texteK
var texteC
var speaking = true
var timer = 0
var speaker = -1
var waitedEvent = []
# var b = "textvar"
var waiting = false
var waited = 0
var eventAfterWait = []
var eventAfterJumpCrush = []
var superGoto = -1

var sound = []

var savedScene

func charge(s):
	speaking = false
	scene = s
	var jsonfile = File.new()
	jsonfile.open("res://histoires/" + str(s) + ".json", File.READ)
	data = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	readySound(data["dialogues"].size(),s)
	jsonfile.open("res://textes/kallypse/" + str(s) + "-0.json",File.READ)
	texteK = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	jsonfile.open("res://textes/kallypse/" + str(s) + "-1.json",File.READ)
	texteC = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	dialogue = data["first"]
	var event = data["dialogues"][dialogue][3]
	start_event(event)
	speaker = -1
	speaking = true

func readySound(n,s):
	sound = []
	s = str(s)
	for i in range(n):
		sound.append(0)
		sound[i] = load("res://voices/kallypse/" + s + "/" + str(i) + ".ogg")

func _ready():
	randomize()
	$MusicPlayer.volume_db = global.get_music_volume()
	$VoicePlayer.volume_db = global.get_voice_volume()
	charge(global.scene)
	
func _process(delta):
	if speaking:
		if speaker == -1:
			# On ne sait pas encore qui est en train de parler
			speaker = data["dialogues"][dialogue][0]
			nTexte = data["dialogues"][dialogue][1]
			$VoicePlayer.set_stream(sound[dialogue])
			$VoicePlayer.play()
			timer = 0
			if superGoto != -1:
				if speaker == 0:
					timer = texteK[nTexte][superGoto][0]
				else:
					timer = texteC[nTexte][superGoto][0]
				superGoto = -1
			$HUD/Kallypse.text = ""
			$HUD/Cerise.text = ""
			# Voilà ! Maintenant on sait et c'est bien plus propre
		timer += delta
		if speaker == 0:
			var i = find_time_id(timer,texteK[nTexte])
			if waiting:
				if waited == i:
					waiting = false
					start_event(eventAfterWait)
					end_event(eventAfterWait)
			$HUD/Kallypse.text = texteK[nTexte][i][1]
			if i == len(texteK[nTexte]) - 1:
				next_line()
		elif speaker == 1:
			var i = find_time_id(timer,texteC[nTexte])
			$HUD/Cerise.text = texteC[nTexte][i][1]
			if i == len(texteC[nTexte]) - 1:
				next_line()
	if waitedEvent != []:
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_select"):
			start_event(waitedEvent)
			end_event(waitedEvent)
			waitedEvent = []


func find_time_id(timu,tex):
	for i in range(len(tex)):
		if timu < tex[i][0]:
			return i - 1
	return len(tex) - 1
		
func next_line():
	var event = data["dialogues"][dialogue][3]
	var goOn = end_event(event)
	if goOn:
		dialogue = data["dialogues"][dialogue][2]
		event = data["dialogues"][dialogue][3]
		start_event(event)
		speaker = -1
	
func end_event(evt):
	for elem in evt:
		var event = data["events"][elem]
		if event[0] == "changeStep":
			charge(event[1])
			return false
		elif event[0] == "generique":
			get_tree().change_scene("res://Generique.tscn")
			return false
	return true
	
func start_event(evt):
	for elem in evt:
		var event = data["events"][elem]
		if event[0] == "goto" or event[0] == "superGoto":
			dialogue = event[1]
			var evtt = data["dialogues"][dialogue][3]
			start_event(evtt)
			speaker = -1
			if event[0] == "superGoto":
				superGoto = event[2]
		elif event[0] == "img":
			$HUD/front_image.set_visible(true)
			$HUD/front_image.set_texture(load("res://images/" + event[1] + ".png"))
		elif event[0] == "deImg":
			$HUD/front_image.set_visible(false)
		elif event[0] == "playSong":
			$MusicPlayer.set_stream(load("res://musiques/kallypse/" + event[1] + ".ogg"))
			$MusicPlayer.play()
		elif event[0] == "deactivateCroissant":
			$ObjetsTable/Croissant.deactivate()
		elif event[0] == "activateCroissant":
			$ObjetsTable/Croissant.activate()
		elif event[0] == "reviveCroissant":
			$ObjetsTable/Croissant.activate()
			$ObjetsTable/Croissant.revive()
		elif event[0] == "waitKey":
			waitedEvent = event[1]
		elif event[0] == "framboise":
			var framb = Framboise.instance()
			$ObjetsTable.add_child(framb)
		elif event[0] == "fausseFramboise":
			var framb = Framboise.instance()
			framb.convert_fish()
			$ObjetsTable.add_child(framb)
		elif event[0] == "finFramboise":
			var frambs = get_tree().get_nodes_in_group('framboise')
			for f in frambs:
				f.state = 2
				f.n = 0
				f.die = true
		elif event[0] == "boss_lapin":
			var framb = Boss_Lapin.instance()
			framb.trigger = event[1]
			$ObjetsTable.add_child(framb)
		elif event[0] == "move":
			get_node("ObjetsTable/" + event[1]).goTo(event[2],event[3])
		elif event[0] == "giveRole":
			get_node("ObjetsTable/" + event[1]).role = event[2]
			get_node("ObjetsTable/" + event[1] + "/Sprite").modulate.a = 1
			if event[2] == "jumpCrush":
				eventAfterJumpCrush = event[3]
		elif event[0] == "tuto_fleches":
			var new_tuto = Tuto_fleches.instance()
			get_node("ObjetsTable/" + event[1]).add_child(new_tuto)
		elif event[0] == "exclamation":
			var new_tuto = Exclamation.instance()
			get_node("ObjetsTable/" + event[1]).add_child(new_tuto)
		elif event[0] == "addPhoto":
			var new_photo = Photo.instance()
			$ObjetsTable.add_child(new_photo)
		elif event[0] == "tuto_roulade":
			var new_tuto = Tuto_Roulade.instance()
			get_node("ObjetsTable/" + event[1]).add_child(new_tuto)
		elif event[0] == "trigger":
			get_node("ObjetsTable/" + event[1]).new_trigger(event[2])
		elif event[0] == "hardTrigger":
			get_node("ObjetsTable/" + event[1]).new_hard_trigger(event[2])
		elif event[0] == "deTrigger":
			get_node("ObjetsTable/" + event[1]).de_trigger()
		elif event[0] == "waitSentence":
			waiting = true
			waited = event[1]
			eventAfterWait = event[2]
		elif event[0] == "moveTrigger":
			$ObjetsTable/Croissant.moveTrigger(event[1])
		elif event[0] == "deMoveTrigger":
			$ObjetsTable/Croissant.deMoveTrigger()
		elif event[0] == "addCerise":
			var crcr = Shooter.instance()
			crcr.position = Vector2(event[1],event[2])
			$ObjetsTable.add_child(crcr)
			$Camera.cible = "CroissantShooter"
		elif event[0] == "removeCerise":
			var frambs = get_tree().get_nodes_in_group('Shooter')
			for f in frambs:
				f.queue_free()
			$Camera.cible = "Croissant"
		elif event[0] == "goElseWhere":
			var new_scene = load("res://" + event[1] + ".tscn")
			var new_node = new_scene.instance()
			var pos_in_parent = $ObjetsTable.get_position_in_parent()
			$ObjetsTable.name = 'truc'
			$truc.queue_free()
			$Camera.cible = event[2]
			new_node.add_to_group("Table")
			new_node.name = 'ObjetsTable'
			add_child(new_node)
			move_child(new_node, pos_in_parent)
		elif event[0] == "stopCamera":
			$Camera.stopMoving()
		elif event[0] == "swap":
			var objA = get_node("ObjetsTable/" + event[1])
			var objB = get_node("ObjetsTable/" + event[2])
			var pospos = objB.position
			objA.immuneToFall = 0.5
			objB.position = objA.position
			objA.position = pospos
			var spritz = objB.get_node("Sprite").texture
			objB.get_node("Sprite").texture = objA.get_node("Sprite").texture
			objA.get_node("Sprite").texture = spritz
			var offoff = objB.get_node("Sprite").offset
			objB.get_node("Sprite").offset = objA.get_node("Sprite").offset
			objA.get_node("Sprite").offset = offoff
			var shasha = objB.get_node("CollisionShape2D").shape
			objB.get_node("CollisionShape2D").shape = objA.get_node("CollisionShape2D").shape
			objA.get_node("CollisionShape2D").shape = shasha
			var pospole = objB.get_node("CollisionShape2D").position
			objB.get_node("CollisionShape2D").position = objA.get_node("CollisionShape2D").position
			objA.get_node("CollisionShape2D").position = pospole
			objA.purifyState()
			
			$Camera.TPmode()
		elif event[0] == "stopRoll":
			$ObjetsTable/Croissant.canRoll = false
		elif event[0] == "startRoll":
			$ObjetsTable/Croissant.canRoll = true
		elif event[0] == "addPostCard":
			global.add_postCard(event[1])
		elif event[0] == "cardPoint":
			if global.countCard() >= event[1]:
				start_event(event[2])
				end_event(event[2])
		elif event[0] == "cardSeen":
			if global.cardSeen(event[1]):
				start_event(event[2])
				end_event(event[2])
			
	
func mort():
	if data["mort"] == -1:
		#$ObjetsTable/Croissant.revive()
		return
	dialogue = data["mort"]
	var event = data["dialogues"][dialogue][3]
	start_event(event)
	speaker = -1
	var jj = get_tree().get_nodes_in_group("JumpingThing")
	for j in jj:
		j.disappear(false)
	
	
func shakeCamera():
	$Camera.shakeDatAss()

func jumpThingDie():
	start_event(eventAfterJumpCrush)
	end_event(eventAfterJumpCrush)
	
