extends KinematicBody2D

var current_pokemon
var next_pokemon = 0
var defeated = false
var list_of_pokemon = []
var battle_scene = preload("res://Scenes/BattleScene.tscn")

onready var sprite = get_node("Sprite")
onready var dialog_box = get_node("/root/PetwerCityGym/GameUI/DialogBox")
onready var game_ui = get_node("/root/PetwerCityGym/GameUI")

export (String) var trainer_name
export (Texture) var trainer_sprite
export (Texture) var battle_sprite
export (Array, String) var pre_battle_dialog
export (Array, String) var post_battle_dialog

signal party_empty()

func _ready():
	sprite.texture = trainer_sprite

func _add_pokemon(pokemon):
	list_of_pokemon.append(pokemon)

func _tell_dialog():
	Global.dialog_box.dialog = pre_battle_dialog

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
		print("dialog activé")
		_tell_dialog()
		yield(Global.dialog_box,"dialog_finished")
		
		if defeated == false:
#			SceneChanger.transition_effect()
#			yield(SceneChanger,"transition_finished")
			_start_fight(body,self)


func _on_DialogRange_body_exited(body):
	if "Player" in body.name:
		print("dialog non-activé")
