extends Node

onready var black = $Black
onready var animation_player = $AnimationPlayer
signal scene_changed()

func change_scene(scene):
	yield(get_tree().create_timer(0.5),"timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene_to(scene) == OK)
	animation_player.play_backwards("fade")
	emit_signal("scene_changed")

func battle_transition():
	yield(get_tree().create_timer(0.5),"timeout")
	animation_player.play("start_battle")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
	
func fade_out(panel):
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	panel.queue_free()
	animation_player.play_backwards("fade")
	emit_signal("scene_changed")
