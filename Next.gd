extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func resize():
	var ss = get_viewport_rect().size
	position.y = ss.y/2
	if ss.x / 1200 < ss.y / 800:
		scale = Vector2(ss.x/1200,ss.x/1200)
	else:
		scale = Vector2(ss.y/800,ss.y/800)

func _process(delta):
	resize()
