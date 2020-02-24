extends Area2D

var state = 1
var g = 0
var offset = 0
var standardY 
var direction
var trigger = 0
var n = 0
var die = false
export var vitesse = 50
export var center = Vector2(990,520)
export var radiusX = 600
export var radiusY = 300
export (PackedScene) var Explosion

func _ready():
	standardY = $Sprite.position.y
	position = center + Vector2(randi()%radiusX,randi()%radiusY) - Vector2(radiusX,radiusY)/2

func _process(delta):
	if state == 1:
		process_jump(delta)
	elif state == 2:
		var expl = Explosion.instance()
		expl.position = position + $Sprite.position
		expl.emitting = true
		expl.one_shot = true
		get_tree().get_nodes_in_group('SortY')[0].add_child(expl)
		queue_free()
		
func process_jump(delta):
	if offset >= 0:
		g = -10
		direction = new_dir()
	offset += g*delta*60
	g += delta*30
	$Sprite.position.y = standardY + offset
	position += direction*delta*vitesse
	
func new_dir():
	var dist = (position - center)
	dist = (dist.x / radiusX)*(dist.x / radiusX) + (dist.y / radiusY)*(dist.y / radiusY)
	if dist <= 1:
		var r = (randi() % 628) / 100
		direction = Vector2(cos(r),sin(r))
	else:
		direction = (center-position).normalized()
	return direction
		
		

func _on_Boss_Lapin_body_entered(body):
	if body.is_in_group('Player'):
		if body.state == 1:
			get_node("/root/General").charge(trigger)
