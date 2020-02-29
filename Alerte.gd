extends Sprite

# class member variables go here, for example:
# var a = 2
var lifeSpan = 3
var pos

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func rota(r):
	$Sprite.rotation = r

func _process(delta):
	lifeSpan -= delta
	if (int(lifeSpan*10)%2 == 0 and lifeSpan < 0.5) or lifeSpan > 2.5:
		$Sprite.set_visible(false)
	else:
		$Sprite.set_visible(true)
	if lifeSpan <= 0:
		queue_free()
	var vec = get_node("/root/General/ObjetsTable/Croissant").position + position
	vec = pos - vec
	$Sprite.rotation = vec.angle()