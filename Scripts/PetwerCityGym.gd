extends Node2D

onready var brock = get_node("Brock")
onready var player = get_node("Player")
export (PackedScene) var target_scene = load("res://Scenes/World.tscn")

func _ready():
	set_brock_team()

func set_brock_team():
	#building brock pokemon team
	var steelix = Pokemon.new("Steelix",50,78,85,200,55,65,30)
	var tyranitar = Pokemon.new("Tyranitar",50,100,134,110,95,100,61)
	var iron_tail = Move.new("Iron Tail",70,100,"iron","physical",10)
	var rock_slide = Move.new("Rock Slide",65,80,"rock","physical",10)
	steelix.add_move(iron_tail)
	steelix.add_move(rock_slide)
	tyranitar.add_move(rock_slide)
	brock._add_pokemon(steelix)
	brock._add_pokemon(tyranitar)


func _on_Exit_body_entered(body):
	if "Player" in body.name:
		pass
		#SceneChanger.change_scene("res://Scenes/World.tscn")

