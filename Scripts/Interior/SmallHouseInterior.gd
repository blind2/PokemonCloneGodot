extends Node2D

onready var player = get_node("Player")
onready var exit = get_node("ExitCarpet")

func _ready():
	Global.door_state = 2
	player.sprite.frame = 7
	VisualServer.set_default_clear_color(Color(0.0,0.0,0.0,1.0))


