extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var speed = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	rotation -= delta * speed
	if rotation <= - 3.20:
		queue_free()
