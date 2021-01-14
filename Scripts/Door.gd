extends Area2D


onready var sprite_animation = get_node("AnimatedSprite")
export	(String, "open_door", "open_gym_door") var door_animation
export (PackedScene) var target_scene 
# export(Texture) var sprite


func _on_Door_body_entered(body):
	if "Player" in body.get_name():
		
		Global.player_spawn_position = self.global_position
		if Global.enter == true:
			body.state = body.STOP
			sprite_animation.show()
			sprite_animation.play(door_animation)
			yield(sprite_animation,"animation_finished")
			SceneChanger.change_scene(target_scene)
			
			Global.enter = false
		
