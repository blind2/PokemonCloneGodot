extends Panel

var dialog_index = 0
var dialog_encounter = true

onready var text= get_node("Text")
onready var delay = get_node("Delay")

export (Array,String) var dialog 

signal dialog_finished()
signal key_pressed()

func _ready():
	delay.wait_time = 0.1
	delay.start()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_A and dialog_encounter == true:
			read_dialog()
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_A:
#			emit_signal("key_pressed")
#			print("key pressed")

func _set_dialog_text(dialog_text):
	text.bbcode_text = dialog_text
	text.percent_visible = 0
	delay.start()

func read_dialog():
	if dialog_index<dialog.size():
		text.bbcode_text = dialog[dialog_index]
		text.percent_visible = 0
		dialog_index+=1
		show()

func _on_Delay_timeout():
	if text.visible_characters<text.bbcode_text.length():
		text.visible_characters += 3
	else:
		emit_signal("dialog_finished")

func _on_DialogBox_dialog_finished():
	text.bbcode_text = ""
	dialog_index = 0
	#hide()
