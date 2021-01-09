extends Node2D

var animation = 0
var animLen = 1
var newImg
var textures = [0,1]
var current
var animating = false
var modif = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for i in range(8):
		if not global.postCards[i]:
			get_node("card" + str(i)).texture = getImg(9)
	current = 0

func _process(delta):
	
	var ss = get_viewport_rect().size
	var s = Vector2(0,0)
	if ss.x / 1200 < ss.y / 800:
		s = Vector2(ss.x/1200,ss.x/1200)
	else:
		s = Vector2(ss.y/800,ss.y/800)		
	var c = modif * animation/animLen
	for i in range(9):
		get_node("card" + str(i)).scale = s
		get_node("card" + str(i)).position.y = ss.y/2
		get_node("card" + str(i)).position.x = ((i + 11 - current)%9 - 1 + c) * ss.x / 2
	
	if not animating:
		modif = 0
		if Input.is_action_pressed("ui_right"):
			modif += 1
		elif Input.is_action_pressed("ui_left"):
			modif -= 1
		if modif != 0:
			current = (current + modif) % 9
			animation = animLen
			animating = true
	else:
		animation -= delta
		if animation <= 0:
			animation = 0
			animating = false
			return
	
	
			
func getImg(n):
	print(n)
	return get_node("card" + str(n)).texture
			
			
			
			
			
