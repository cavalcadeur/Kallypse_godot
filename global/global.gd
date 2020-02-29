extends Node

var scene = 1
var postCards = [true,true,true,false,false,false,false,false]

func save_game():
	var save_game = File.new()
	save_game.open("user://kallypseSave.save", File.WRITE)
	save_game.store_line(to_json(postCards))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://kallypseSave.save"):
		postCards = [false,false,false,false,false,false,false,false]
		scene = 1
	else:
		save_game.open("user://kallypseSave.save", File.READ)
		scene = 666
		postCards = parse_json(save_game.get_line())
		
func add_postCard(n):
	if n >= 0 and n < postCards.size():
		postCards[n] = true
	save_game()