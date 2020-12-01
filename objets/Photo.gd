extends Node2D

# class member variables go here, for example:
# var a = 2
var speedX = 800
var deSpeed = 200
var g = -5


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	position = Vector2(-500,500)

func _process(delta):
	position.x += speedX*delta
	speedX -= delta*deSpeed
	if speedX <= 0:
		speedX = 0
	elif g < 5:
		$Sprite.rotation += delta*(9 - g)
		position.y += g * delta * 30
		g += delta*4
