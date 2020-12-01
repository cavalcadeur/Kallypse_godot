extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	scale = Vector2(0.01,0.01)

func _process(delta):
	var power = floor(delta / 0.002)
	
	scale *= pow(1.015,power)
	rotation += delta
	if scale.x > 15:
		queue_free()


