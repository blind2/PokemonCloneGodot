extends KinematicBody2D

var current_pokemon
var next_pokemon = 0
var list_of_pokemon = []
var defeated = false
var battle_scene = preload("res://Scenes/BattleScene.tscn")
var comunicate = false
onready var sprite = get_node("Sprite")

export (String) var trainer_name
export (Texture) var trainer_sprite
export (Texture) var battle_sprite
export (Array, String) var pre_battle_dialog
export (Array, String) var post_battle_dialog

signal party_empty()

func _ready():
	#Aligne et centre le dresseur avec les tuiles de jeu
	sprite.texture = trainer_sprite
	position = position.snapped(Vector2.ONE * 16) 
	position += Vector2.ONE * 16/2 
	

func _add_pokemon(pokemon):
	list_of_pokemon.append(pokemon)

func set_dialog(dialog):
	Global.dialog_box.dialog = dialog

func refacing(player):
	var player_current_direction = player.current_direction
	var player_direction = player.DIRECTION
	
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
	 var max_number = get_pokemon().list_of_moves.size() - 1
	 var rng = RandomNumberGenerator.new()
	 rng.randomize()
	 var random_number = rng.randi_range(0, max_number)
	
	 return  get_pokemon().list_of_moves[random_number]

func _start_fight(player, opponent):
	current_pokemon = list_of_pokemon[0]
	var new_battle_scene = battle_scene.instance()
	new_battle_scene.create_battle_scene(player, opponent)
	Global.game_ui.add_child(new_battle_scene)

func check_party_empty():
	next_pokemon+=1
	if next_pokemon<list_of_pokemon.size():
		current_pokemon = list_of_pokemon[next_pokemon]
	else:
		defeated = true
		return true

func set_trainer_frame(frame):
	sprite.frame = frame

func get_pokemon():
	return current_pokemon


func _on_DialogRange_body_entered(body):
	if "Player" in body.name:
		Global.dialog_box.dialog_encounter = true
		#body.state = body.STOP
		refacing(body)
		print("dialog activé")
	
		if !defeated:
			set_dialog(pre_battle_dialog)
			
			SceneChanger.transition_effect()
			yield(SceneChanger,"transition_finished")
			_start_fight(body,self)
			pass
		if defeated:
			set_dialog(post_battle_dialog)


func _on_DialogRange_body_exited(body):
	if "Player" in body.name:
		print("dialog non-activé")
		Global.dialog_box.dialog_encounter = false
		#Global.dialog_box.hide()
