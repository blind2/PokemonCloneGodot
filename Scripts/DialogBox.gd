extends Panel

var dialog_index = 0
var dialog_encounter = true
export (Array,String) var dialog 
onready var text= get_node("Text")
onready var delay = get_node("Delay")

signal dialog_finished()
signal key_pressed()

func _ready():
	delay.wait_time = 0.1


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_A and dialog_encounter ==true:
			_next_line()
			show()
			delay.start()
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_A:
			emit_signal("key_pressed")

func _set_dialog_text(dialog_text):
	text.bbcode_text = dialog_text
	text.percent_visible = 0
	delay.start()


func _next_line():
	if dialog_index<dialog.size():
		text.bbcode_text = dialog[dialog_index]
		text.percent_visible = 0
		dialog_index+=1
	else:
		emit_signal("dialog_finished")
		#queue_free()
		dialog_index = 0

func _on_Delay_timeout():
	if text.visible_characters<text.bbcode_text.length():
		text.visible_characters+=3

