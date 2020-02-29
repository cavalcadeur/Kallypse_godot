extends Sprite

var speed = 500
var goal
export (PackedScene) var Explosion

func _ready():
	position.y = -50
	for i in range(5):
		get_node("Sprite" + str(i+1)).rotation = (randi()%628) / 100

func ready():
	var scrSize = get_viewport_rect().size
	position.x = randi() % int(scrSize.x)
	goal = randi() % int(scrSize.y / 2)

func _process(delta):
	position.y += delta * speed
	for i in range(5):
		get_node("Sprite" + str(i+1)).rotation += delta * speed / 30
	if position.y > goal:
		queue_free()
