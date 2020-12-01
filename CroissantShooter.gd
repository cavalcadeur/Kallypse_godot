extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var r = 0
export var speed = 200
var shootBuffer = 0
export (PackedScene) var Framb

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta): 
	var velocity = 0
	if Input.is_action_pressed("ui_right"):
		r += 0.1
	if Input.is_action_pressed("ui_left"):
		r -= 0.1
	if Input.is_action_pressed("ui_down"):
		velocity -= 1
	if Input.is_action_pressed("ui_up"):
		velocity += 1
	if Input.is_action_pressed("ui_select") and shootBuffer <= 0:
		shootBuffer = 0.2
		var f = Framb.instance()
		f.initializing = false
		f.position = position + 50*Vector2(cos(r),sin(r) + 0.3)
		f.direction = Vector2(cos(r),sin(r)) * f.speed
		f.state = 1
		f.die = true
		f.n = 0
		get_node("/root/General/ObjetsTable").add_child(f)
	var collision = move_and_collide(velocity*delta*Vector2(cos(r),sin(r)) * speed)
	if collision:
		var compos = collision.remainder.slide(collision.normal)
		position += compos
	$Sprite.rotation = r
	$CollisionShape2D.rotation = r
	if shootBuffer > 0:
		shootBuffer -= delta
