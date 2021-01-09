extends KinematicBody2D

var objectif = Vector2(0,0)
var going = false
export var vitesse = 500
var role = "none"
var safeZone = 200
export (PackedScene) var Shadow
export (PackedScene) var JumpingThing
var g = 0
var offset = 0
var standardY
var trigger
var is_a_trigger = false
var is_hard = false
export var triggerZone = 120

export var hitType = "standard"

export var speed = 400
export var center = Vector2(990,520)
export var radiusX = 600
export var radiusY = 300
export var deathRadius = 45
var sens = Vector2(0,0)
var state = 2
var strat = 1
var cible = null
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func getRandomLocation():
	var liste = [[360,400],[820,844],[1185,680],[900,300],[1325,353],[1735,520],[1465,840],[980,643],[966,350],[685,190]]
	var h = randi() % len(liste)
	return Vector2(liste[h][0],liste[h][1])

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	standardY = $Sprite.position.y

func _process(delta):
	if going:
		var direction = objectif - position
		if direction.length() <= vitesse*delta:
			going = false
			position.x = objectif.x
			position.y = objectif.y
		else:
			direction = direction.normalized() * vitesse
			position += direction * delta
	elif role == "ellebore":
		if state < 0 and state > -0.5:
			if strat == 0:
				state += delta/2
				position.x += sin(state*200)*1.5
				position.y += sin(state*180)*1.1
				if cible == null:
					cible = get_tree().get_nodes_in_group('Player')[0].position
			elif strat == 1:
				state += delta/2
				$Sprite.modulate.a = abs(state + 0.25) * 4
				if state < -0.25 and cible == null:
					cible = get_tree().get_nodes_in_group('Player')[0].position
					var r = (randi()%628) / 100
					position = cible + Vector2(cos(r),sin(r)) * 250
			else:
				strat = randi() % 2
		elif state < -0.5 and strat == 0:
			state = 1
			strat = 55
			var oldOne = $Sprite.position + position
			position = cible
			var vect = position + $Sprite.position - oldOne
			var n = 5
			vect = vect / n
			cible = get_tree().get_nodes_in_group('Player')[0].position
			cible -= position
			if cible.length() <= deathRadius:
				get_node("/root/General/ObjetsTable/Croissant").die()
			for i in range(n):
				var s = Shadow.instance()
				s.position = oldOne + i*vect
				s.alpha = (i+1)*100/n
				s.texture = $Sprite.texture
				get_node('/root/General/ObjetsTable').add_child(s)
			cible = null
		elif state < -0.5 and strat == 1:
			cible = get_tree().get_nodes_in_group('Player')[0].position
			cible -= position
			if cible.length() <= deathRadius:
				get_node("/root/General/ObjetsTable/Croissant").die()
			cible = cible.normalized()
			position += cible * delta * 500
			if state < -1.1:
				state = 1
				strat = 55
				cible = null
		state -= delta
	elif role == "ninja":
		var target = get_tree().get_nodes_in_group('Player')[0].position
		var direction = target - position
		if offset >= 0:
			g = -5
		offset += g*delta*55
		g += delta*40
		$Sprite.position.y = standardY + offset
		if direction.length() <= safeZone or not onTable():
			var oldOne = $Sprite.position + position
			position = getRandomLocation()
			var vect = position + $Sprite.position - oldOne
			var n = 5
			vect = vect / n
			for i in range(n):
				var s = Shadow.instance()
				s.position = oldOne + i*vect
				s.alpha = (i+1)*100/n
				s.texture = $Sprite.texture
				get_tree().get_nodes_in_group('SortY')[0].add_child(s)
	elif role == "flee":
		if offset >= 0:
			g = -5
			sens = new_dir()
		offset += g*delta*75
		g += delta*40
		position += sens * delta * speed
		$Sprite.position.y = standardY + offset
	elif role == "jumpCrush":
		var j = JumpingThing.instance()
		j.position = position
		get_node("/root/General/ObjetsTable").add_child(j)
		position = Vector2(-10000,-10000)
		role = "none"
	elif role == "fall":
		role = "startled"
		state = 1.5
	elif role == "fadeAway":
		role = "fading"
		state = 1
	elif role == "fading":
		state -= delta
		if state < 0:
			position = Vector2(-3000,-3000)
			role = "none"
		else:
			$Sprite.modulate.a = state
	elif role == "startled":
		$Sprite.rotation += sin(state*10)*(1.5-state)*delta
		state -= delta
		if state <= 0:
			role = "falling"
			state = 1.5
	elif role == "shakeABit":
		$Sprite.scale.x = 1 + sin(state*15)*(state*0.2)
		$Sprite.scale.y = 1 - sin(state*15)*(state*0.2)
		state -= delta
		if state <= 0:
			role = "none"
			state = 0
			$Sprite.scale.y = 1
	elif role == "falling":
		$Sprite.rotation += delta*state
		state += delta*2
		if $Sprite.rotation >= 1.57:
			role = "none"
			$Sprite.rotation = 1.57
			get_node("/root/General").shakeCamera()
	elif is_a_trigger:
		var target = get_tree().get_nodes_in_group('Player')[0].position
		if (target - position).length() <= triggerZone:
			if (not is_hard):
				get_node("/root/General").start_event(trigger)
				get_node("/root/General").end_event(trigger)
				de_trigger()


func new_dir():
	var direction
	var dist = (position - center)
	dist = (dist.x / radiusX)*(dist.x / radiusX) + (dist.y / radiusY)*(dist.y / radiusY)
	if dist <= 1:
		var target = position - get_tree().get_nodes_in_group('Player')[0].position
		target = target.normalized()
		var r = (randi() % 414 - 207) / 100.0
		direction = Vector2(cos(r),sin(r)) + target
		direction = direction.normalized()
	else:
		direction = (center-position).normalized()
	return direction

func onTable():
	return get_tree().get_nodes_in_group('Table')[0].overlaps_body(self)

func goTo(x,y):
	going = true
	objectif.x = x
	objectif.y = y

func new_trigger(trig):
	trigger = trig
	is_a_trigger = true

func new_hard_trigger(trig):
	new_trigger(trig)
	is_hard = true

func de_trigger():
	trigger = []
	is_a_trigger = false
	is_hard = false

func isHit():
	if hitType == "cafe":
		$AnimatedSprite.burst()
		state = 0.8
		role = "shakeABit"
	elif hitType == "theiere":
		state = 0.4 
		role = "shakeABit"
		
	if is_a_trigger && is_hard:
		get_node("/root/General").start_event(trigger)
		get_node("/root/General").end_event(trigger)
		de_trigger()
