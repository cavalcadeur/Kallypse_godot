extends Control

# class member variables go here, for example:
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
# var b = "textvar"

func charge(s):
	speaking = false
	scene = s
	var jsonfile = File.new()
	jsonfile.open("res://histoires" + str(s) + ".json", File.READ)
	data = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	jsonfile.open("res://textes/kallypse/" + str(s) + "-0.json",File.READ)
	texteK = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	jsonfile.open("res://textes/kallypse/" + str(s) + "-1.json",File.READ)
	texteC = parse_json(jsonfile.get_as_text())
	jsonfile.close()
	dialogue = data["first"]
	speaking = true

func _ready():
	pass
	
func _process(delta):
	if speaking:
		if speaker == -1:
			# On ne sait pas encore qui est en train de parler
			speaker = data["dialogues"][dialogue][0]
			nTexte = data["dialogues"][dialogue][1]
			timer = 0
			$Kallypse.text = ""
			$Cerise.text = ""
			# Voilà ! Maintenant on sait et c'est bien plus propre
		timer += delta
		if speaker == 0:
			i = find_time_id(timer,texteK[nTexte])
			$Kallypse.text = texteK[nTexte][i]
			if i == len(texteK[nTexte]):
				next_line()
		elif speaker == 1:
			i = find_time_id(timer,texteC[nTexte])
			$Cerise.text = texteC[nTexte][i]
			if i == len(texteC[nTexte]):
				next_line()
			
func find_time_id(timer,tex):
	for i in range(len(tex)):
		if timer < tex[i][0]:
			return i - 1
	return i
		
func next_line():
	
