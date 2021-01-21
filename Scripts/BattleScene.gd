extends Control

var player
var opponent
var selection
var battle_state = INTRO
var first_pokemon

var player_pokemon 
var opponent_pokemon 

onready var player_texture = get_node("PlayerPokemon")
onready var opponent_texture = get_node("OpponentPokemon")
onready var player_frame = get_node("PlayerFrame")
onready var opponent_frame = get_node("OpponentFrame")
onready var dialog_box = get_node("CombatDialogBox")
onready var moves_panel = get_node("Moves")
onready var action_panel = get_node("Action")
onready var tween = get_node("Tween")
onready var delay = get_node("Delay")
onready var battle_animation= get_node("BattleAnimation")
onready var pokemon_menu = get_node("PokemonMenu")

signal state_changed()

enum{
	INTRO,
	SELECT_ACTION,
	SELECT_MOVE
	CHANGE_TURN,
	PLAYER_TURN,
	OPPONENT_TURN,
	PLAYER_DEATH,
	OPPONENT_DEATH,
	OPPONENT_DEFEATED,
	OPPONENT_SWITCH,
	PLAYER_SWITCH,
	GAIN_EXPERIENCE
}

func create_battle_scene(player, opponent):
	self.player = player
	self.opponent = opponent

func _ready():
	update_battle()
	#print(str(player_pokemon.get_amount_of_experience(opponent_pokemon)))

func change_state(state):
	battle_state = state
	emit_signal("state_changed")

func update_battle():
	match battle_state:
		INTRO:
			battle_intro()
		SELECT_ACTION:
			action_panel.show()
		SELECT_MOVE:
			moves_panel.show()
			action_panel.hide()
		CHANGE_TURN:
			change_turn()
		PLAYER_TURN:
			player_turn()
		OPPONENT_TURN:
			trainer_turn()
		OPPONENT_DEATH:
			opponent_pokemon_dead()
		OPPONENT_DEFEATED:
			opponent_defeated()
		OPPONENT_SWITCH:
			opponent_switch_pokemon()
		PLAYER_SWITCH:
			player_switch_pokemon()
		GAIN_EXPERIENCE:
			gain_experience()

func get_move_data(index, node_name):
	#Vérifie si le pokemon contient des attaques
	if player_pokemon.get_move(index) != null:
		moves_panel.get_node(node_name).text = player_pokemon.get_move(index).move_name
	elif player_pokemon.get_move(index) == null:
		moves_panel.get_node(node_name).text = "-----"
		moves_panel.get_node(node_name).disabled = true

func get_player_pokemon_data():
	player_pokemon = player.party.get_pokemon() #represente le premier pokemon de l'equipe de du joueur
	pokemon_menu.player_party = player.party
	
	player_texture.texture = (load("res://Assets/Pokemon/Back/"+player_pokemon.back_sprite))
	player_frame.get_node("HpBar").max_value = player_pokemon.hp
	player_frame.get_node("HpBar").value = player_pokemon.current_hp
	player_frame.get_node("ExpBar").max_value = player_pokemon.experience_required
	player_frame.get_node("ExpBar").value = player_pokemon.experience
	player_frame.get_node("Lvl").text = "lvl "+str(player_pokemon.level)
	player_frame.get_node("Name").text = player_pokemon.pokemon_name
	
	get_move_data(0,"Move1")
	get_move_data(1,"Move2")
	get_move_data(2,"Move3")
	get_move_data(3,"Move4")

func get_opponent_pokemon_data():
	opponent_pokemon = opponent.party.get_pokemon() #represente le premier pokemon de l'equipe de l'adverssaire
	
	opponent_texture.texture = (load("res://Assets/Pokemon/Front/"+opponent_pokemon.front_sprite))
	opponent_frame.get_node("HpBar").max_value = opponent_pokemon.hp
	opponent_frame.get_node("HpBar").value = opponent_pokemon.current_hp
	opponent_frame.get_node("Lvl").text = "lvl "+str(opponent_pokemon.level)
	opponent_frame.get_node("Name").text = opponent_pokemon.pokemon_name

func battle_intro():
	get_player_pokemon_data()
	get_opponent_pokemon_data()
	opponent_texture.texture = opponent.battle_sprite
	battle_animation.play("start_fight")
	dialog_box.set_combat_text(opponent.trainer_name+" would like to battle")
	yield(get_tree().create_timer(2),"timeout")
	yield(dialog_box,"text_finished")
	battle_animation.play("opponent_switch")
	dialog_box.set_combat_text(opponent.name+" send out "+opponent_pokemon.pokemon_name+" !")
	yield(battle_animation,"animation_finished")
	battle_animation.play("opponent_switch_pokemon")
	opponent_texture.texture = (load("res://Assets/Pokemon/Front/"+opponent_pokemon.front_sprite))
	print(opponent_texture.texture)
	yield(battle_animation,"animation_finished")
	
	battle_animation.play("player_switch")
	dialog_box.set_combat_text("Go "+player_pokemon.pokemon_name+" !")
	yield(battle_animation,"animation_finished")
	battle_animation.play("player_switch_pokemon")
	player_texture.texture = (load("res://Assets/Pokemon/Back/"+player_pokemon.back_sprite))
	yield(battle_animation,"animation_finished")
	player_frame.show()
	opponent_frame.show()
	
	change_state(SELECT_ACTION)

func change_turn():
	moves_panel.hide()
	if player_pokemon.speed > opponent_pokemon.speed:
		first_pokemon = player_pokemon
		change_state(PLAYER_TURN)
		
	elif opponent_pokemon.speed > player_pokemon.speed:
		first_pokemon = opponent.get_pokemon()
		change_state(OPPONENT_TURN)
	else:
		pass # à completer

func player_turn():
	dialog_box.set_combat_text(player_pokemon.pokemon_name+" used "+ player_pokemon.get_move(selection).move_name)
	yield(dialog_box,"text_finished")
	battle_animation.play("opponent_damage_taken")
	yield(battle_animation,"animation_finished")
	player_pokemon.attack(player_pokemon.get_move(selection),opponent_pokemon)
	_bar_animation(opponent_frame.get_node("HpBar"), opponent_pokemon.current_hp)
	yield(tween,"tween_completed")
	
	if(opponent_pokemon.dead()):
		change_state(OPPONENT_DEATH)
		
	elif first_pokemon == player_pokemon:
		change_state(OPPONENT_TURN)
		
	else:
		change_state(SELECT_ACTION)

func trainer_turn():
	dialog_box.set_combat_text(opponent_pokemon.pokemon_name+" used "+opponent.choose_move().move_name)
	yield(dialog_box,"text_finished")
	battle_animation.play("player_damage_taken")
	yield(battle_animation,"animation_finished")
	opponent_pokemon.attack(opponent.choose_move(),player_pokemon)
	_bar_animation(player_frame.get_node("HpBar"),player_pokemon.current_hp)
	yield(tween,"tween_completed")
	
	if player_pokemon.dead():
		change_state(PLAYER_DEATH)
		
	elif first_pokemon == opponent_pokemon:
		change_state(PLAYER_TURN)
		
	else:
		change_state(SELECT_ACTION)

func player_pokemon_dead():
	dialog_box.set_combat_text(player_pokemon.pokemon_name+" as fainted !")
	action_panel.hide()

func opponent_pokemon_dead():
	action_panel.hide()
	dialog_box.set_combat_text(opponent_pokemon.pokemon_name+" as fainted !")
	yield(get_tree().create_timer(2),"timeout")
	opponent_texture.visible = false
	yield(dialog_box,"text_finished")
	get_player_pokemon_data() #update exp bar 
	player_pokemon.gain_experience(player_pokemon.get_amount_of_experience(opponent_pokemon))
	dialog_box.set_combat_text(player_pokemon.pokemon_name+" gained "+str(player_pokemon.experience_total)+" experiences")

	opponent_frame.hide()
	
	change_state(GAIN_EXPERIENCE)

func gain_experience():
	#remplie la barre de progress au maximum pour chaque niveaux completé
	if player_pokemon.level_completed > 0:
		for i in range(player_pokemon.level_completed):
			if i < player_pokemon.level_completed - 1:
				_bar_animation(player_frame.get_node("ExpBar"),player_pokemon.experience_required)
				yield(tween,"tween_completed")
				player_frame.get_node("ExpBar").value = 0 #remmet la barre à 0 quand elle est a 100 %
	
	#remplie le restant de la barre de progress avec le restant de l'experience
	_bar_animation(player_frame.get_node("ExpBar"),player_pokemon.experience)
	yield(tween,"tween_completed")
	
	player_frame.get_node("Lvl").text = "lvl "+str(player_pokemon.level)
	yield(dialog_box,"text_finished")
	player_pokemon.reset_experience_total()
	
	if opponent.party.check_party_empty():
		change_state(OPPONENT_DEFEATED)
		
	else:
		change_state(OPPONENT_SWITCH)

func player_switch_pokemon():
	battle_animation.play_backwards("player_switch_pokemon")
	yield(battle_animation,"animation_finished")
	battle_animation.play("player_switch_pokemon")
	get_player_pokemon_data() #update pokemon data
	dialog_box.set_combat_text("Go "+player_pokemon.pokemon_name+" !")
	player_texture.texture = (load("res://Assets/Pokemon/Back/"+player_pokemon.back_sprite)) # update pokemon sprite
	yield(battle_animation,"animation_finished")
	change_state(OPPONENT_TURN)


func opponent_switch_pokemon():
	get_opponent_pokemon_data()
	dialog_box.set_combat_text(opponent.trainer_name+" send out "+opponent_pokemon.pokemon_name)
	yield(dialog_box,"text_finished")
	battle_animation.play_backwards("opponent_switch_pokemon")
	yield(battle_animation,"animation_finished")
	opponent_texture.visible = true
	battle_animation.play("opponent_switch_pokemon")
	yield(battle_animation,"animation_finished")
	opponent_frame.show()
	action_panel.show()

func opponent_defeated():
	action_panel.hide()
	dialog_box.set_combat_text("Congrulation you have beat ! "+opponent.trainer_name)
	yield(dialog_box,"text_finished")
	yield(get_tree().create_timer(2),"timeout")
	
	opponent.status = opponent.STATUS.DEFEATED # change le status du joueur pour ne plus le re combattre
	player.state = player.WALK #change l'etat du joueur pour marcher
	player.is_battling = false 
	SceneChanger.fade_out(self)

func _bar_animation(bar, stat):
	tween.interpolate_property(bar,"value", bar.value,stat,
	2.0,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Fight_pressed():
	change_state(SELECT_MOVE)

func _on_Move1_pressed():
	selection = 0
	change_state(CHANGE_TURN)

func _on_Move2_pressed():
	selection =  1
	change_state(CHANGE_TURN)

func _on_Move3_pressed():
	selection = 2
	change_state(CHANGE_TURN)

func _on_Move4_pressed():
	selection = 3
	change_state(CHANGE_TURN)

func on_BattleScene_state_changed():
	update_battle()

func _on_Run_pressed():
	SceneChanger.fade_out(self)

func _on_Pokemon_pressed():
	action_panel.hide()
	moves_panel.hide()
	pokemon_menu.show()

func _on_PokemonMenu_switch_pokemon():
	change_state(PLAYER_SWITCH)

func _on_PokemonMenu_cancel():
	change_state(SELECT_ACTION)
