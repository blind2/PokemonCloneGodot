extends Area2D

onready var animation_player = get_node("AnimationPlayer")
export (PackedScene) var target_scene 
onready var player = get_node("/root/World/Forest/YSort/Player")


func _on_Door_body_entered(body):
	if "Player" in body.get_name():
		
		Global.player_spawn_position = self.global_position
		if Global.enter == true:
			body.state = body.STOP
			animation_player.play("open_door")
			yield(animation_player,"animation_finished")
			player.animation_player.play("move_up")
			yield(player.animation_player,"animation_finished")
			animation_player.play_backwards("open_door")
			yield(animation_player,"animation_finished")
			SceneChanger.change_scene(target_scene)
			
			Global.enter = false
		
