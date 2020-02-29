extends Sprite

var speed = 850
var goal
export (PackedScene) var Explosion
var time = 0

func _ready():
	position.y = get_viewport_rect().size.y + 50
	for i in range(4):
		get_node("Sprite" + str(i+1)).rotation = (randi()%628) / 100

func ready():
	var scrSize = get_viewport_rect().size
	position.x = randi() % int(scrSize.x)
	goal = randi() % int(scrSize.y / 2)

func _process(delta):
	time += delta
	position.y -= delta * speed
	for i in range(4):
		get_node("Sprite" + str(i+1)).rotation += delta * speed / 15
		get_node("Sprite" + str(i+1)).position.x = sin((time + i*0.75)*18)*8
	if position.y <= goal:
		var expl = Explosion.instance()
		expl.position = position
		expl.emitting = true
		expl.one_shot = true
		get_node("/root/Generique").add_child(expl)
		queue_free()
