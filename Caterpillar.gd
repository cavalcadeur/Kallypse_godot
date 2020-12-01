extends Node2D

var pos = []
var r = 0
var rSpeed = 0
export var speed = 300
var time = 0
var scales = [1,1,1,1]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pos = initPos()
	for i in range(4):
		scales[i] = get_node("Sprite" + str(i + 1)).get_scale().x

func _process(delta):
	time += delta*5
	pos[0] += Vector2(cos(r),sin(r)) * delta * speed
	position = pos[0]
	r += rSpeed * delta * 10
	rSpeed += float(randi()%10 - 5) / 40
	rSpeed = clamp(rSpeed, - 0.15, 0.15)
	for i in range(1,4):
		pos[i] = (12 * pos[i] + pos[i-1])/13
		get_node("Sprite" + str(i + 1)).position = pos[i] - pos[0]
	if (position.x < -100):
		position.x = 1950
		for i in range(4):
			pos[i] = position
	elif (position.x > 2020):
		position.x = -50
		for i in range(4):
			pos[i] = position
			
	if (position.y < -800):
		position.y = 1050
		for i in range(4):
			pos[i] = position
	elif (position.y > 1100):
		position.y = -750
		for i in range(4):
			pos[i] = position
			
	for i in range(4):
		var taille = scales[i] + cos(time + i*1.57)/15
		get_node("Sprite" + str(i + 1)).set_scale(Vector2(taille,taille))
		
func initPos():
	var value = Vector2(randi() % 1500,randi() % 1500)
	return [value,value + $Sprite2.position,value + $Sprite3.position,value + $Sprite4.position]
	
