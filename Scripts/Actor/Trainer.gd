extends KinematicBody2D

var party = Party.new()
var defeated = false
var battle_scene = preload("res://Scenes/BattleScene.tscn")

onready var sprite = get_node("Sprite")
onready var change_direction = get_node("ChangeDirectionDelay")
onready var player = get_node("/root/World/Forest/YSort/Player")

onready var dialog_zone = get_node("DialogZone")

export (String) var trainer_name
export (Texture) var trainer_sprite
export (Texture) var battle_sprite

var pre_battle_dialog = []
var post_battle_dialog = []

signal party_empty()

func _ready():
	#Aligne et centre le dresseur avec les tuiles de jeu
	sprite.texture = trainer_sprite
	position = position.snapped(Vector2.ONE * 16) 
	position += Vector2.ONE * 16/2 
	
	change_direction.wait_time = 0.8
	change_direction.start()
	
	dialog_zone.create(self)


func get_post_battle_dialog():
	Global.dialog_box.dialog = post_battle_dialog

func get_pre_battle_dialog():
	Global.dialog_box.dialog = pre_battle_dialog

func refacing():
	var player_current_direction = player.player_input.input
	var player_direction = player.player_input
	
	if player_current_direction == player_direction.UP:
		set_trainer_frame(0)
		
	elif player_current_direction == player_direction.DOWN:
		set_trainer_frame(3)
		
	elif player_current_direction == player_direction.LEFT:
		set_trainer_frame(2)
		
	elif player_current_direction == player_direction.RIGHT:
		set_trainer_frame(1)

#choisi une attaque au hasard dans la liste d'attaque du pokemon
func choose_move():
	 var max_number = party.get_pokemon().list_of_moves.size() - 1
	 var rng = RandomNumberGenerator.new()
	 rng.randomize()
	 var random_number = rng.randi_range(0, max_number)
	
	 return  party.get_pokemon().list_of_moves[random_number]

func start_fight():
	#current_pokemon = list_of_pokemon[0]
	var new_battle_scene = battle_scene.instance()
	new_battle_scene.create_battle_scene(player,self)
	Global.game_ui.add_child(new_battle_scene)


func set_trainer_frame(frame):
	sprite.frame = frame


func _on_ChangeDirectionDelay_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var frame = rng.randi_range(0,3)
	set_trainer_frame(frame)

