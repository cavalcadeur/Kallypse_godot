extends Area2D

var state = 0
var n = 0
var target
var direction = Vector2(0,0)
var die = false
var isFish = false
var initializing = true
export var appearTime = 2.5
export var disappearTime = 1.5
export var speed = 40
export var targetTime = 5
export (PackedScene) var Explosion
export (PackedScene) var Alerte

export var vitesse = 50
export var center = Vector2(990,520)
export var radiusX = 600
export var radiusY = 300

func _ready():
	
	if initializing:
		$Sprite.modulate.a = 0
		state = 0
		target = get_tree().get_nodes_in_group('Player')[0]
		var truc = get_tree().get_nodes_in_group('Player')[0].position
		var rh = randi()%3141/500.0
		position = truc + Vector2(cos(rh),sin(rh)) * speed * 0.5
		n = 0
		var expl = Alerte.instance()
		expl.pos = position
		get_node("/root/General/ObjetsTable/Croissant").add_child(expl)

func _process(delta):
	if state == 0:
		act_appear(delta)
	elif state == 1:
		act_target(delta)
	elif state == 2:
		act_disappear(delta)

func act_appear(delta):
	$Sprite.modulate.a = n / appearTime
	n += delta
	if n >= appearTime:
		n = 0
		state = 1
		$Sprite.modulate.a = 1
		direction = target.position - position
		direction = direction.normalized() * speed
		#var rh = direction.angle()
		
func act_target(delta):
	position += direction * delta
	n += delta
	if n >= targetTime:
		n = 0
		state = 2
		
func act_disappear(delta):
	$Sprite.modulate.a = 1 - (n / disappearTime)
	n += delta
	position += direction * delta
	if n >= disappearTime:
		n = 0
		state = 0
		var truc = get_tree().get_nodes_in_group('Player')[0].position
		var rh = randi()%3141/500.0
		position = truc + Vector2(cos(rh),sin(rh)) * speed * 0.5
		direction = Vector2(0,0)
		if die:
			queue_free()
		else:
			var expl = Alerte.instance()
			expl.pos = position
			get_node("/root/General/ObjetsTable/Croissant").add_child(expl)
			
		
		

func convert_fish():
	isFish = true



func _on_Framboise_body_entered(body):
	if isFish and state == 1:
			state = 2
			n = 0
			direction *= -0.3
	elif body.is_in_group("obstacle") and state == 1:
		n = disappearTime
		var expl = Explosion.instance()
		expl.position = position
		expl.emitting = true
		expl.one_shot = true
		get_tree().get_nodes_in_group('SortY')[0].add_child(expl)
		state = 2
	elif body.is_in_group("Player") and state == 1:
		if isFish:
			state = 2
			n = 0
			direction *= -0.5
		else:
			var expl = Explosion.instance()
			expl.position = position
			expl.emitting = true
			expl.one_shot = true
			get_tree().get_nodes_in_group('SortY')[0].add_child(expl)
			body.die()
			queue_free()
