extends Node2D

onready var lady = get_node("Lady")
onready var bug_catcher = get_node("BugCatcher")

func _ready():
	lady.set_trainer_frame(2)
	bug_catcher.set_trainer_frame(0)
	set_bug_catcher_team()

func set_lady_team():
	pass

func set_bug_catcher_team():
	var beedril = Pokemon.new("Beedrill", 45 ,65, 90, 40, 45, 80, 75)
	var poison_jab = Move.new("Poison Jab", 80, 100, "flying", "physical", 10)
	beedril.add_move(poison_jab)
	bug_catcher._add_pokemon(beedril)
