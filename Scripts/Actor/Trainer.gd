extends KinematicBody2D

var party = Party.new()
var status = STATUS.UNDEFEATED
var battle_scene = preload("res://Scenes/BattleScene.tscn")

onready var dialog_box = get_node("/root/World/GameUI/DialogBox")
onready var game_ui = get_node("/root/World/GameUI")

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

enum STATUS {
	DEFEATED,
	UNDEFEATED
}

func _ready():
	#Aligne et centre le dresseur avec les tuiles de jeu
	sprite.texture = trainer_sprite
	position = position.snapped(Vector2.ONE * 16) 
	position += Vector2.ONE * 16/2 
	
	change_direction.wait_time = 0.8
	change_direction.start()

func interact():
	if status == STATUS.DEFEATED:
		get_post_battle_dialog()
	if status == STATUS.UNDEFEATED:
		get_pre_battle_dialog()

func get_post_battle_dialog():
	print(post_battle_dialog)
	Global.dialog_box.dialog = post_battle_dialog
	dialog_box.read_dialog(post_battle_dialog)

func get_pre_battle_dialog():
	print(pre_battle_dialog)
	dialog_box.dialog = pre_battle_dialog
	dialog_box.read_dialog(pre_battle_dialog)

"""
Ropositione le NPC vers la direction du joueur quand il communique avec le joueur
"""
func refacing(player):
	var player_current_direction = player.current_direction
	var player_direction = player.DIRECTION
	
	if player_current_direction == player_direction.UP:
		set_trainer_frame(0)
		change_direction.stop()
		
	elif player_current_direction == player_direction.DOWN:
		set_trainer_frame(3)
		change_direction.stop()
		
	elif player_current_direction == player_direction.LEFT:
		set_trainer_frame(2)
		change_direction.stop()
		
	elif player_current_direction == player_direction.RIGHT:
		set_trainer_frame(1)
		change_direction.stop()

"""
Choisi une attaque au hasard dans la liste d'attaque du pokemon
"""
func choose_move():
	 var max_number = party.get_pokemon().list_of_moves.size() - 1
	 var rng = RandomNumberGenerator.new()
	 rng.randomize()
	 var random_number = rng.randi_range(0, max_number)
	
	 return  party.get_pokemon().list_of_moves[random_number]

func start_fight():
	yield(dialog_box,"dialog_finished")
	SceneChanger.transition_effect()
	yield(SceneChanger,"transition_finished")
	var new_battle_scene = battle_scene.instance()
	new_battle_scene.create_battle_scene(player,self)
	game_ui.add_child(new_battle_scene)


func set_trainer_frame(frame):
	sprite.frame = frame

func _on_ChangeDirectionDelay_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var frame = rng.randi_range(0,3)
	set_trainer_frame(frame)

