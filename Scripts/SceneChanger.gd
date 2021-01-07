extends Node

onready var black = $Black
onready var animation_player = $AnimationPlayer
signal scene_changed()
signal transition_finished()

func change_scene(path):
	yield(get_tree().create_timer(0.5),"timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade")
	emit_signal("scene_changed")

func transition_effect():
	yield(get_tree().create_timer(0.5),"timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	yield(get_tree().create_timer(0.5),"timeout")
	animation_player.play_backwards("fade")
	emit_signal("transition_finished")
