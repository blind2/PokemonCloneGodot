extends Node
class_name PlayerInput

var input = IDLE

enum {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	IDLE
}

func update():
	mouvement()

func mouvement():
	if Input.is_action_pressed("ui_up"):
		input = UP
	elif Input.is_action_pressed("ui_down"):
		input  = DOWN
	elif Input.is_action_pressed("ui_left"):
		input = LEFT
	elif Input.is_action_pressed("ui_right"):
		input = RIGHT
	else:
		input = IDLE

func accept():
	if Input.is_action_just_pressed("ui_a"):
		return true
	elif Input.is_action_just_released("ui_a"):
		return false

func back():
	if Input.is_action_just_pressed("ui_s"):
		return true
	elif Input.is_action_just_released("ui_s"):
		return false
