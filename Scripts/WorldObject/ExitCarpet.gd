extends Area2D

export (PackedScene) var target_scene  =load("res://Scenes/World.tscn")

func _ready():
	Global.align_object_with_grid(self)

func _on_ExitCarpet_body_entered(body):
	if "Player" in body.name:
		SceneChanger.change_scene(target_scene)
#		var dialogbox_instance = dialog_box.instance()
#		add_child(dialogbox_instance)
		body.state = body.STOP
		yield(SceneChanger,"scene_changed")
