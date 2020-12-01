extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var speed = 300
var scrolling = 0.2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://main.tscn")
	$Camera2D.position.y += delta*speed
	if ($Camera2D.position.y >= 1500):
		scrolling -= delta
		if scrolling <= 0:
			get_tree().change_scene("res://main.tscn")
