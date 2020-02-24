extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var baseOffset
var t = 0
var buffer = 2
export var speed = 100

func _ready():
	print(get_path())
	baseOffset = $up.position.y

func _physics_process(delta):
	$up.position.y = baseOffset + sin(t*2)*12
	t += delta
	
	if buffer > 0:
		buffer -= delta
	else:
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
			velocity = velocity.normalized() * speed
		var collision = move_and_collide(velocity*delta)
		if collision:
			var compos = collision.remainder.slide(collision.normal)
			position += compos