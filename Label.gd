extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var value = 0
var buffer = 0.2
var velocity = 0
var firstTime = true
var wait = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var screen_size = get_viewport_rect().size
	var rapport = screen_size.x / 1800
	set_scale(Vector2(rapport,rapport))
	set_position(Vector2((screen_size.x - rapport*200) * 0.5,screen_size.y * 0.65))
	for i in range(3):
		get_node("Menu" + str(i)).set_visible((i == value))
	if Input.is_action_pressed("ui_down"):
		velocity = 1
	elif Input.is_action_pressed("ui_up"):
		velocity = 2
	else:
		wait = buffer
		
	wait += delta
	if velocity > 0:
		if wait >= buffer:
			wait = 0
			value = (value+velocity)%3
		velocity = 0
	
	if Input.is_action_pressed("ui_select"):
		if value == 0:
			get_tree().change_scene("res://main.tscn")
		elif value == 2:
			get_tree().quit()
		elif value == 1:
			get_tree().change_scene("res://postcards.tscn")
			
			
			