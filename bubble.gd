extends AnimatedSprite

var pos = Vector2(0,0)
var s
var state
export var timeOut = 8
export var factor = 1.01
export var speedUp = -200

func _ready():
	state = 0
	s = 0.01
	position = Vector2(0,0)
	set_scale(Vector2(s,s))

func _process(delta):
	if state == 0:
		position += Vector2(0,speedUp) * delta
		s *= factor
		if s > 0.6:
			s = 0.6
			state = 1
			play()
		set_scale(Vector2(s,s))
	elif state == 2:
		s /= 1.05
		if s <= 0.01:
			queue_free()
		else:
			set_scale(Vector2(s,s))
	elif state == 1:
		timeOut -= delta
		if timeOut <= 0:
			state = 2
	
func die():
	state = 2