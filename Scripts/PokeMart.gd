extends Node2D

onready var vendor = get_node("Vendor")
onready var player = get_node("Player")
onready var game_ui = get_node("GameUI")
onready var shop_panel = get_node("Shop/ShopPanel")
var world_scene =  load("res://Scenes/World.tscn")
onready var dialog_box = get_node("/root/PokeMartInterior/GameUI/DialogBox")


func _ready():
	player.get_node("Sprite").set_frame(7)

 
func _on_Exit_body_entered(body):
	if "Player" in body.get_name():
		print(body.name)
		SceneChanger.change_scene(world_scene)

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		dialog_box.dialog_encounter = true
		vendor._tell_dialog()
		yield(dialog_box,"dialog_finished")
		shop_panel.show()
