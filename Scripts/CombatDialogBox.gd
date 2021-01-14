extends NinePatchRect

onready var text = get_node("Text")
onready var timer = get_node("Timer")

signal text_finished()

func _ready():
	timer.wait_time =  0.1

func set_combat_text(combat_text):
	text.bbcode_text = combat_text
	text.percent_visible = 0
	timer.start()


func _on_Timer_timeout():
	if text.visible_characters<text.bbcode_text.length():
		text.visible_characters += 3
	else:
		
		emit_signal("text_finished")
	
