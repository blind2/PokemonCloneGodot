extends Area2D

export (PackedScene) var target_scene  =load("res://Scenes/World.tscn")

func _ready():
	Global.align_object_with_grid(self)

func _on_ExitCarpet_body_entered(body):
	if "Player" in body.name:
		body.state = body.STOP
		SceneChanger.change_scene(target_scene)
		yield(SceneChanger,"scene_changed")
		
