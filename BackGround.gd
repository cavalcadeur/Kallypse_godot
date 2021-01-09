extends Sprite

# class member variables go here, for example:
# var a = 2
var screen_size

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(_delta):
	if is_visible():
		screen_size = get_viewport_rect().size
		var sizu = get_texture().get_size()
		var rapport = screen_size.x / sizu.x
		set_scale(Vector2(rapport,rapport))
		set_position(Vector2(rapport * sizu.x * 0.5,screen_size.y - sizu.y * rapport * 0.5))
