extends Area2D

export (Texture) var sprite
export (Array, String) var npc_dialog
onready var dialog_box = get_node("/root/PokeMartInterior/GameUI/DialogBox")

func _tell_dialog():
	dialog_box.dialog = npc_dialog
