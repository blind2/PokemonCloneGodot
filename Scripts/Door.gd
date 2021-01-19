extends Area2D

onready var animation_player = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
export (PackedScene) var target_scene 
onready var player = get_node("/root/World/Forest/YSort/Player")

enum {
	ENTER,
	EXIT
}

func _on_Door_body_entered(body):
	if "Player" in body.get_name():
		Global.player_spawn_position = self.global_position
		if Global.door_state == 1 :
			body.state = body.STOP
			animation_player.play("open_door")
			player.animation_player.play("move_up")
			yield(player.animation_player,"animation_finished")
			player.visible = false
			animation_player.play_backwards("open_door")
			yield(animation_player,"animation_finished")
			SceneChanger.change_scene(target_scene)
			
			
		if Global.door_state == 2:
			sprite.frame = 3
			player.visible = false
			yield(get_tree().create_timer(0.5),"timeout")
			player.visible = true
			animation_player.play_backwards("open_door")
			player.animation_player.play("move_down")
			yield(animation_player,"animation_finished")
			
			Global.door_state = 1
			
			
			
