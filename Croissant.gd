extends KinematicBody2D
signal hit

export var rollDuration = 0.4
export var speed = 540  # Vitesse du Croissaaaaaaaaant
var screen_size
var state
var r
var rollTime
var dir
export var rollSpeedMul = 1.7
var nCr
export var crushSpeed = 8
var standardY
var g = 0
var onTable = true
var standardPos
var tutoOn = false
var checkMove = false
var moveEvent = []
var checkBuffer = 0
export var checkBufferLimit = 10
var canRoll = true


func _ready():
	screen_size = get_viewport_rect().size
	state = 0
	r = 0
	rollTime = 0
	dir = Vector2()
	standardY = $Sprite.position.y
	standardPos = position
	

func process_norm(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		if checkMove:
			checkBuffer += 1
			if checkBuffer >= checkBufferLimit:
				checkMove = false
				get_node("/root/General").start_event(moveEvent)
				get_node("/root/General").end_event(moveEvent)
		if Input.is_action_pressed("ui_select") and canRoll:
			state = 1
			dir = velocity.normalized() * speed * rollSpeedMul
			rollTime = rollDuration
		velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity*delta)
	if collision:
		var compos = collision.remainder.slide(collision.normal)
		position += compos

func process_roll(delta):
	var boobool = test_move(transform,dir * delta)
	if boobool:
		dir *= -1.2
		state = 2
		nCr = 0
	else:
		position += dir * delta
	rollTime -= delta
	var rotSens = 1
	if dir.x < 0:
		rotSens = -1
	$Sprite.rotation += speed * delta * 0.1 * rotSens
	if rollTime <= 0:
		state = 0
		$Sprite.rotation = 0

func process_crush(delta):
	var liste = [Vector2(-0.15,0.15),Vector2(0.15,-0.15),Vector2(-0.08,0.08),Vector2(0.08,-0.08)]
	var i = floor(nCr*crushSpeed)
	nCr += delta
	$Sprite.scale += liste[i] * delta * 30
	if nCr*crushSpeed >= 4:
		$Sprite.scale = Vector2(1,1)
		state = 1

func process_fall(delta):
	$Sprite.position.y += g*delta*50
	if g < 40:
		g += delta*20 
	else:
		state = 0
		$Sprite.position.y = standardY
		position = standardPos
		g = 0
		onTable = true
		$Sprite.rotation = 0
		r = 0

func _process(delta):
	pass

func _physics_process(delta):
	if state == 0:
		process_norm(delta)
	elif state == 1:
		process_roll(delta)
	elif state == 2:
		process_crush(delta)
	elif state == 5:
		process_fall(delta)

func deactivate():
	state = 3
	r = 0
	$Sprite.rotation = 0
	$Sprite.scale = Vector2(1,1)
	#$Sprite/Camera2D.deactivate()

func activate():
	state = 0
	#$Sprite/Camera2D.activate()

func die():
	deactivate()
	get_tree().get_nodes_in_group('chef')[0].mort()

func _on_Croissant_hit():
	dir *= -1

func _on_Croissant_body_entered(body):
	dir *= -1

func fall():
	state = 5
	onTable = false
	if position.y < 500:
		var YY = get_node("/root/General/ObjetsTable/Table").position.y - 1
		$Sprite.position.y += position.y - YY
		position.y = YY
	 
func moveTrigger(ev):
	checkMove = true
	moveEvent = ev
	
	
	
	