extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var screen_size = get_viewport_rect().size
	var sizu = get_texture().get_size()
	var rapport = screen_size.x / 1920
	set_scale(Vector2(rapport,rapport))
	set_position(Vector2(screen_size.x * 0.5,screen_size.y * 0.3))

