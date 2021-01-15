extends Node

onready var dialog_box = get_node("/root/World/GameUI/DialogBox")
onready var game_ui = get_node("/root/World/GameUI")
onready var player 

var player_spawn_position = Vector2(300,300)
var enter = true
const TILE_SIZE = 16

var world

func get_player_position(player):
	player_spawn_position = player.position

func align_object_with_grid(object):
	object.position = object.position.snapped(Vector2.ONE * TILE_SIZE) 
	object.position += Vector2.ONE *  TILE_SIZE/2 
