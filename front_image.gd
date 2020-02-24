extends Sprite

var screen_size
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	screen_size = get_viewport_rect().size
	centered = true

func _process(delta):
	if is_visible():
		screen_size = get_viewport_rect().size
		var sizu = get_texture().get_size()
		var rapport = screen_size.x / sizu.x
		set_scale(Vector2(rapport,rapport))
		set_position(Vector2(rapport * sizu.x * 0.5,screen_size.y - sizu.y * rapport * 0.5))