extends Node2D

onready var lady = get_node("Lady")
onready var bug_catcher = get_node("BugCatcher")

func _ready():
	lady.set_trainer_frame(2)
	bug_catcher.set_trainer_frame(0)
	set_bug_catcher_team()
	set_lady_team()

func set_lady_team():
	var feraligatr = Pokemon.new("Feraligatr",30, 85, 105, 100, 79, 85, 78)
	var surf = Move.new("Surf", 90, 100, "water", "special", 10)
	var ice_punch = Move.new("Ice Punch", 75, 100, "ice", "special", 15)
	feraligatr.add_move(surf)
	feraligatr.add_move(ice_punch)
	lady._add_pokemon(feraligatr)
	

func set_bug_catcher_team():
	var beedril = Pokemon.new("Beedrill", 45 ,65, 90, 40, 45, 80, 75)
	var poison_jab = Move.new("Poison Jab", 80, 100, "poison", "physical", 10)
	beedril.add_move(poison_jab)
	bug_catcher._add_pokemon(beedril)
