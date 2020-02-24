extends Label

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if is_visible():
		screen_size = get_viewport_rect().size
		set_size(Vector2(round(0.75 * screen_size.x),round(screen_size.y/5)))
		set_position(Vector2(screen_size.x * 1/8,screen_size.y * 0.8))