extends Node2D

export var center = Vector2(0,0)
var shake = 0
var cible = "Croissant"
var moving = true
var speed = 8
var TP = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	cible = "Croissant"

func _process(delta):
	if TP:
		var targetPos = (get_node("/root/General/ObjetsTable/" + cible).position + center) / 2
		if (targetPos - position).length() < delta*speed:
			TP = false
		else:
			position += delta * speed * (targetPos - position)
	elif moving:
		position = get_node("/root/General/ObjetsTable/" + cible).position + center
		position /= 2
		if shake > 0:
			shake -= delta
			position.x += sin(shake*100)*150
			position.y -= cos(shake*90)*100 + 20

func shakeDatAss():
	shake = 0.4
	
func stopMoving():
	position = center
	moving = false
	
func TPmode():
	TP = true
