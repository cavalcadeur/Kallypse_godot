extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screen_size

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	screen_size = get_viewport_rect().size
	var rapport = screen_size.x / 1800
	set_scale(Vector2(rapport,rapport))
	set_position(Vector2((screen_size.x - rapport*800) * 0.5,rapport * 50))
