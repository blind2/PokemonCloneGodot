extends Control

onready var quantity = get_node("ItemsDescription/Quantity")
onready var item_desciption = get_node("ItemsDescription")
onready var item_price = get_node("ItemsDescription/Price")

export (Array, String, "Pokeball", "Potion", "Escape Rope", "Antidote", "Paralyze Heal", "Burn Heal") var items_array 

func _ready():
	hide()
	_items_description_update(0)
	for i in range(items_array.size()):
			create_custom_button(i)
	

func _items_description_update(index):
	match items_array[index]:
		"Pokeball":
			item_price.text = str(150)+" $"
			item_desciption.text = "A Ball throw to catch a wild pokemon. It designed in a capsule style."
		"Potion":
			item_price.text = str(100)+" $"
			item_desciption.text = "A spray-type wound medicine. It restores the HP of one Pokémon by 20 points."
		"Escape Rope":
			item_price.text = str(500)+" $"
			item_desciption.text = "A long, durable rope. Use it to escape instantly from a cave or a dungeon."
		"Antidote":
			item_price.text = str(100)+" $"
			item_desciption.text = "A spray-type medicine. It lifts the effect of poison from one Pokémon."
		"Paralyse Heal":
			item_price.text = str(200)+" $"
			item_desciption.text = "A spray-type medicine. It heals one Pokémon from paralysis."
		"Burn Heal":
			item_price.text = str(200)+" $"
			item_desciption.text = "A spray-type medicine. It heals one Pokémon of a burn."
		"Awakening":
			item_price.text = str(200)+" $"
			item_desciption .text = "A spray-type medicine. It awakens a sleeping Pokémon."


func create_custom_button(index):
	var button = Button.new()
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/pokemon_fire_red.ttf")
	font.size = 30
	button.add_font_override("font", font)
	button.add_color_override("font_color",Color(255,255,255))
	button.name = "item"+str(index)
	button.text = str(items_array[index])
	button.icon = (load("res://Assets/Icons/"+button.text+".png"))
	button.expand_icon = true
	button.set_position(Vector2(590,70+(50*index)))
	button.set_size(Vector2(340,45))
	button.connect("pressed",self,"on_"+button.name+"_button_pressed")
	add_child(button)
	print(button.text)

func on_button_pressed(button):
	print(button.text)

func on_item0_button_pressed():
	_items_description_update(0)

func on_item1_button_pressed():
	_items_description_update(1)

func on_item2_button_pressed():
	_items_description_update(2)

func on_item3_button_pressed():
	_items_description_update(3)

func on_item4_button_pressed():
	_items_description_update(4)

func on_item5_button_pressed():
	_items_description_update(5)

func _on_Buy_pressed():
	var total = int(item_price.text)*int(quantity.text)
	print(quantity.text)
	print(str(total))

func _on_Exit_pressed():
	hide()
