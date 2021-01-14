extends Area2D

export (PackedScene) var target_scene  =load("res://Scenes/World.tscn")

func _ready():
	Global.align_object_with_grid(self)

func _on_ExitCarpet_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene_to(Global.world)
		body.state = body.STOP
		yield(SceneChanger,"scene_changed")
