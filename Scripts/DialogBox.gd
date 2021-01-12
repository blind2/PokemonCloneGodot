extends NinePatchRect

var dialog_index = 0
var dialog_encounter = false
var accept_key = true
onready var text= get_node("Text")
onready var delay = get_node("Delay")
var array  = preload("res://Scenes/Array.tscn")
onready var player = get_node("/root/World/Player")

export (Array,String) var dialog 

var start = true
signal dialog_finished()
signal next_line()


func _ready():
	#array.get_node("AnimationPlayer").play("moving_array")
	delay.wait_time = 0.1

func _input(event):
	if event is InputEventKey and dialog_encounter == true:
		if event.pressed and event.scancode == KEY_A and start == true:
			show()
			delay.start()
			read_dialog(dialog)
			start = false

func _set_dialog_text(dialog_text, key_press):
	accept_key = key_press
	text.bbcode_text = dialog_text
	text.percent_visible = 0
	delay.start()

func read_dialog(dialog):
	if dialog_index<dialog.size():
		text.bbcode_text = dialog[dialog_index]
		text.percent_visible = 0
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
	text.bbcode_text = ""
	dialog_index = 0
	delay.stop()
	hide()

func _on_DialogBox_next_line():
	dialog_index+=1
	start = true
	if accept_key == true:
		delay.stop()
	else:
		delay.start()
	
	
