extends Area2D

var trainer


func create(trainer):
	self.trainer = trainer


func _on_DialogZone_body_entered(body):
	Global.dialog_box.dialog_encounter = true
	trainer.refacing()
	print("dialog activé")
	if !trainer.defeated:
		trainer.get_pre_battle_dialog()
		yield(Global.dialog_box,"dialog_finished")
		SceneChanger.transition_effect()
		yield(SceneChanger,"transition_finished")
		trainer.start_fight()


func _on_DialogZone_body_exited(body):
	Global.dialog_box.dialog_encounter = false
	Global.dialog_box.hide()
	print("dialog désactivé")
