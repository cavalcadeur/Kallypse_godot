extends Sprite

var alpha = 0

func _ready():
	pass

func _process(delta):
	modulate.a = alpha/100
	alpha -= delta * 100
	if alpha <= 0:
		queue_free()