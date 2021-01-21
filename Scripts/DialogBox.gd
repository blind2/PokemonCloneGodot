extends NinePatchRect

var dialog = []
var dialog_index = 0
var start = true
var dialog_encounter = true

onready var text= get_node("Text")
onready var delay = get_node("Delay")

signal dialog_finished()
signal next_line()

func _ready():
	delay.wait_time = 0.1

func read_dialog(dialog):
	if dialog_index<dialog.size():
		if start == true:
			text.bbcode_text = dialog[dialog_index]
			text.percent_visible = 0
			delay.start()
			show()
			start = false
	else:
		emit_signal("dialog_finished")
		print("dialog finished")

func _on_Delay_timeout():
	if text.visible_characters<text.bbcode_text.length():
		text.visible_characters += 3
	else:
		#le texte a terminée de s'afficher
		emit_signal("next_line")
		print("line finished")

func _on_DialogBox_dialog_finished():
	dialog_index = 0
	start = true
	hide()

func _on_DialogBox_next_line():
	dialog_index+=1
	delay.stop()
	start = true
	
