extends Node

var scene = 1
var postCards = [false,false,false,false,false,false,false,false,false]
var settings = [3,3,0,true]
var volumeMusic = [-80,-35,-30,-17,0,7]
var volumeVoice = [-80,-30,-17,0,7,15]
var t = [0,0,0]

func ready_theme():
	t[0] = Theme.new()
	t[0].set_color("font_color", "Label", Color(0.0, 0.0, 0.0))
	t[1] = Theme.new()
	t[1].set_color("font_color", "Label", Color(1.0, 1.0, 1.0))
	t[2] = Theme.new()
	t[2].set_color("font_color", "Label", Color(0.0, 0.0, 0.0))

func save_game():
	var save_game = File.new()
	save_game.open("user://kallypseSave.save", File.WRITE)
	save_game.store_line(to_json(postCards))
	save_game.store_line(to_json(settings))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://kallypseSave.save"):
		postCards = [false,false,false,false,false,false,false,false,false]
		scene = 1
	else:
		save_game.open("user://kallypseSave.save", File.READ)
		scene = 666
		postCards = parse_json(save_game.get_line())
		settings = parse_json(save_game.get_line())
		if postCards.size() == 8:
			postCards.append(false)
		
func add_postCard(n):
	if n >= 0 and n < postCards.size():
		postCards[n] = true
	save_game()
	
func countCard():
	var count = 0
	for a in postCards:
		if a:
			count += 1
	return count
	
func cardSeen(evt):
	for c in evt:
		if postCards[c]:
			return true
	return false

func addSetting(n,k):
	var limit = 5
	if n == 2:
		limit = 1
	settings[n] += k
	if settings[n] > limit:
		settings[n] = limit
	elif settings[n] < 0:
		settings[n] = 0
		
func get_music_volume():
	return volumeMusic[settings[0]]
	
func get_voice_volume():
	return volumeVoice[settings[1]]
	
func change_label(_node):
	return
	#node.set_theme(t[settings[2]])


