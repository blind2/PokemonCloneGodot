extends Control

var player_party 
var sellection = 0
onready var animation_player = get_node("AnimationPlayer")
onready var option_menu = get_node("OptionMenu")
onready var switch = get_node("OptionMenu/Switch")
onready var party1 = get_node("Party1")
onready var party2 = get_node("Party2")
onready var party3 = get_node("Party3")
onready var party4 = get_node("Party4")
onready var party5 = get_node("Party5")
onready var party6 = get_node("Party6")

signal switch_pokemon()
signal cancel()

func _ready():
	animation_player.play("moving_pokemon")

func _process(delta):
	set_pokemon_data(party1, 0)
	set_pokemon_data(party2, 1)
	set_pokemon_data(party3, 2)
	set_pokemon_data(party4, 3)
	set_pokemon_data(party5, 4)
	set_pokemon_data(party6, 5)

func get_party_pokemon(index):
	if index < player_party.list_of_pokemon.size():
		return player_party.list_of_pokemon[index]
	else:
		return null

func set_pokemon_data(party,index):
	if get_party_pokemon(index) != null:
		party.get_node("HPBar").value = get_party_pokemon(index).current_hp 
		party.get_node("HPBar").max_value = get_party_pokemon(index).hp
		party.get_node("CurrentHP").text = String(get_party_pokemon(index).current_hp)
		party.get_node("TotalHP").text = String(get_party_pokemon(index).hp)
		party.get_node("Level").text = String(get_party_pokemon(index).level)
		party.get_node("PokemonName").text = get_party_pokemon(index).pokemon_name
		party.get_node("PokemonSprite").texture = (load("res://Assets/Pokemon/Menu/"+get_party_pokemon(index).menu_sprite))
		party.show()
	else:
		party.disabled = true
		party.hide()

func _on_Cancel_pressed():
	self.hide()
	emit_signal("cancel")

func _on_Switch_pressed():
	emit_signal("switch_pokemon")
	player_party.current_pokemon =  sellection #update current pokemon
	option_menu.hide()
	hide()

func _on_OptionMenuCancel_pressed():
	option_menu.hide()

func _on_Party1_pressed():
	option_menu.show()
	switch.disabled = true
	sellection = 0

func _on_Party2_pressed():
	option_menu.show()
	switch.disabled = false
	sellection = 1

func _on_Party3_pressed():
	option_menu.show()
	switch.disabled = false
	sellection = 2

func _on_Party4_pressed():
	option_menu.show()
	switch.disabled = false
	sellection = 3

func _on_Party5_pressed():
	option_menu.show()
	switch.disabled = false
	sellection = 4

func _on_Party6_pressed():
	option_menu.show()
	switch.disabled = false
	sellection = 5
