extends Sprite

# class member variables go here, for example:
# var a = 2
var img = 0
var textu = -1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	position = get_viewport_rect().size/2
	resize()

func resize():
	var ss = get_viewport_rect().size
	if ss.x / 1200 < ss.y / 800:
		scale = Vector2(ss.x/1200,ss.x/1200)
	else:
		scale = Vector2(ss.y/800,ss.y/800)

func _process(delta):
	resize()
	position.y = get_viewport_rect().size.y/2
	if img != textu:
		textu = img
		if global.postCards[img]:
			texture = load("res://images/postCards/" + str(img) + ".png")
		else:
			texture = load("res://images/postCards/8.png")
			
