extends Node2D

export var center = Vector2(0,0)
var shake = 0
var cible = "Croissant"
var moving = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	cible = "Croissant"

func _process(delta):
	if moving:
		position = get_node("/root/General/ObjetsTable/" + cible).position + center
		position /= 2
		if shake > 0:
			shake -= delta
			position.x += sin(shake*100)*200
			position.y += cos(shake*90)*200

func shakeDatAss():
	shake = 0.4
	
func stopMoving():
	position = center
	moving = false