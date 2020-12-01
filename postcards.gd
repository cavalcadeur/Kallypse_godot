extends Node2D

var animation = 0
var animLen = 1
var newImg
var textures = [0,1]
var current

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	current = 0
	if global.postCards[0]:
		$Current.texture = getImg(0)
	else:
		$Current.texture = getImg(9)

func _process(delta):
	if animation == 0:
		var modif = 0
		if Input.is_action_pressed("ui_right"):
			modif += 1
		elif Input.is_action_pressed("ui_left"):
			modif -= 1
		if modif != 0:
			animation = animLen
			newImg = (current + modif + 9)%9
			if global.postCards[newImg]:
				$Next.texture = getImg(newImg)
			else:
				$Next.texture = getImg(9)
			$Next.position.x = get_viewport_rect().size.x * (1/2 + modif)
	else:
		animation -= delta
		if animation <= 0:
			animation = 0
			$Current.img = newImg
			$Current.textu = newImg
			if global.postCards[newImg]:
				$Current.texture = getImg(newImg)
			else:
				$Current.texture = getImg(9)
			current = newImg
			return
		else:
			var useful = get_viewport_rect().size.x / 2
			var sens = -1
			if $Next.position.x < useful:
				sens = 1
			$Current.position.x = useful * (1 + 2*sens*(1 - animation/animLen))
			$Next.position.x = useful * (1 - 2*sens*(animation/animLen))
			
func getImg(n):
	print(n)
	return get_node("card" + str(n)).texture
			
			
			
			
			
