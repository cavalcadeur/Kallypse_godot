extends Area2D

var offsetY = 0
var baseS
var baseC
var g = 0
var timeout = 0
var crushing = false
var touched = 0
export var timeOnGround = 0.6
export var speed = 300
export (PackedScene) var Shadow

func _ready():
	baseS = $Sprite.position.y
	baseC = $CollisionShape2D.position.y
	var s = Shadow.instance()
	s.position = position
	get_node("/root/General/ObjetsTable").add_child(s)

func _process(delta):
	if offsetY >= 0:
		if timeout <= 0:
			timeout = timeOnGround
			get_node("/root/General").shakeCamera()
			if crushing:
				get_node("/root/General").mort()
				disappear()
		timeout -= delta
		if touched > 0:
			# Ici faire la gestion de la mort de la theiere sauteuse.
			disappear()
		g = 0
		offsetY = 0
		if timeout > 4 * timeOnGround/5:
			$Sprite.scale.y *= 0.996
		elif timeout <= 0:
			$Sprite.scale.y = 1
			g = -40
		elif timeout <= timeOnGround / 5:
			$Sprite.scale.y /= 0.996
	offsetY += g*delta*60
	g += delta*32
	$Sprite.position.y = baseS + offsetY
	$CollisionShape2D.position.y = baseC + offsetY
	if offsetY <= -850:
		var target = get_tree().get_nodes_in_group('Player')[0].position + Vector2(0,5)
		target -= position
		target = target.normalized() * speed * delta
		position += target
	get_node("/root/General/ObjetsTable/TheiereShadow").position = position + Vector2(0,-50)

func _on_JumpingTheiere_body_entered(body):
	if body.is_in_group("Player"):
		crushing = true

func _on_JumpingTheiere_body_exited(body):
	if body.is_in_group("Player"):
		crushing = false

func disappear():
	get_node("/root/General").jumpThingDie()
	get_node("/root/General/ObjetsTable/Theiere").position = position
	get_node("/root/General/ObjetsTable/TheiereShadow").disappear()
	queue_free()

func _on_JumpingTheiere_area_entered(area):
	if area.is_in_group("framboise"):
		touched += 1


func _on_JumpingTheiere_area_exited(area):
	if area.is_in_group("framboise"):
		touched -= 1
