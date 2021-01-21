extends Control

var world = preload("res://Scenes/World.tscn")

func _on_CurrentGame_pressed():
	SceneChanger.change_scene(world)
