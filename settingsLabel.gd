extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var value = 0
var wait = 0
var canGo = false
var velocity = 0
var buffer = 0.2
var playing = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	canGo = false
	global.change_label($SousTitres)

func _process(delta):
	$Volume0.animation = str(global.settings[0])
	$Volume1.animation = str(global.settings[1])
	$SousTitres.text = ["Off","On"][global.settings[2]]
	for i in range(5):
		get_node("Sprite" + str(i)).set_visible((i == value))
	var screen_size = get_viewport_rect().size
	var rapport = screen_size.x / 1800
	set_scale(Vector2(rapport,rapport))
	set_position(Vector2((screen_size.x - rapport*700) * 0.5,screen_size.y * 0.5 - rapport * 100))
	
	if Input.is_action_pressed("ui_down"):
		velocity = 1
	elif Input.is_action_pressed("ui_up"):
		velocity = 4
	elif Input.is_action_pressed("ui_right"):
		velocity = -1
	elif Input.is_action_pressed("ui_left"):
		velocity = -3
	else:
		wait = buffer
		
	wait += delta
	if velocity != 0:
		if wait >= buffer:
			wait = 0
			if velocity > 0:
				value = (value+velocity)%5
			else:
				if value < 3:
					global.addSetting(value,velocity + 2)
					$MusicPlayer.volume_db = global.get_music_volume()
					$VoicePlayer.volume_db = global.get_voice_volume()
					global.change_label($SousTitres)
		velocity = 0
		
	if Input.is_action_pressed("ui_select"):
		if not canGo:
			return
		if value == 4:
			global.save_game()
			get_tree().change_scene("res://Menu.tscn")
		if value == 3:
			canGo = false
			testFire()
	else:
		canGo = true
		
func testFire():
	if playing:
		$MusicPlayer.stop()
		$VoicePlayer.stop()
	else:
		$MusicPlayer.volume_db = global.get_music_volume()
		$VoicePlayer.volume_db = global.get_voice_volume()
		$MusicPlayer.play()
		$VoicePlayer.play()
	playing = not playing
	
