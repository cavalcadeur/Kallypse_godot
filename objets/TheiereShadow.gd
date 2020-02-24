extends Sprite

# class member variables go here, for example:
# var a = 2
export var fadeTime = 0.5
var fade

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	fade = fadeTime + 1

func _process(delta):
	if fade > 0 and fade <= fadeTime:
		fade -= delta
		modulate.a = fade / fadeTime
	elif fade < 0:
		queue_free()
	
func disappear():
	fade = fadeTime