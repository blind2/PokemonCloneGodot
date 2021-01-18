extends Node2D

onready var player = get_node("YSort/Player")
onready var lady = get_node("YSort/Lady")
onready var bug_catcher = get_node("YSort/Josh")
onready var house = get_node("YSort/House")
onready var ysort = get_node("YSort")

onready var dialog_box = $DialogBox

func _ready():
	player.position = Global.player_spawn_position
	Global.align_object_with_grid(player)
	Global.align_object_with_grid(house)
	#get every node inside this
	set_bug_catcher_team()
	set_lady_team()

func set_lady_team():
	var feraligatr = Pokemon.new(40, PokemonData.feraligatr)
	var surf = Move.new(MoveData.surf)
	var ice_punch = Move.new(MoveData.ice_punch)
	
	feraligatr.add_move(surf)
	feraligatr.add_move(ice_punch)
	lady.party.add_pokemon(feraligatr)
	
	lady.pre_battle_dialog =[
		"I wonder if you are good enough for me?",
		"this is a test string"
	]
	
	lady.post_battle_dialog = [
		"I never wanted to lose to anybody, especially to a younger kid…"
	]
	

func set_bug_catcher_team():
	var beedril = Pokemon.new(50, PokemonData.beedrill)
	var poison_jab = Move.new(MoveData.poison_jab)
	
	beedril.add_move(poison_jab)
	bug_catcher.party.add_pokemon(beedril)
	
	bug_catcher.pre_battle_dialog = [
		"Hey ! You are not wearing shorts !",
		"What's wrong with you ?"
	]
	
	bug_catcher.post_battle_dialog = [
		"One day i want to be good like you"
	]
	

