extends Panel

var player
var opponent
var selection
var battle_state = INTRO
var first_pokemon

onready var player_pokemon = get_node("PlayerPokemon")
onready var opponent_pokemon = get_node("OpponentPokemon")
onready var player_frame = get_node("PlayerFrame")
onready var opponent_frame = get_node("OpponentFrame")
onready var dialog_box = get_node("DialogBox")
onready var moves_panel = get_node("Moves")
onready var action_panel = get_node("Action")
onready var tween = get_node("Tween")
onready var delay = get_node("Delay")
onready var battle_animation= get_node("BattleAnimation")

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
	GAIN_EXPERIENCE
}

func create_battle_scene(player, opponent):
	self.player = player
	self.opponent = opponent

func _ready():
	update_battle()

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
		GAIN_EXPERIENCE:
			gain_experience()


func get_player_pokemon_data(index):
	player_pokemon.texture = (load("res://Assets/Pokemon/"+player.get_pokemon(index).pokemon_name+".png"))
	player_frame.get_node("HpBar").max_value = player.get_pokemon(index).hp
	player_frame.get_node("HpBar").value = player.get_pokemon(index).current_hp
	player_frame.get_node("ExpBar").max_value = player.get_pokemon(index).experience_required
	player_frame.get_node("ExpBar").value = player.get_pokemon(index).experience
	player_frame.get_node("Lvl").text = "lvl "+str(player.get_pokemon(0).level)
	player_frame.get_node("Name").text = player.get_pokemon(index).pokemon_name
	moves_panel.get_node("Move1").text = player.get_pokemon(index).get_move(0).move_name
	moves_panel.get_node("Move2").text = player.get_pokemon(index).get_move(1).move_name

func get_opponent_pokemon_data():
	opponent_pokemon.texture = (load("res://Assets/Pokemon/"+opponent.get_pokemon().pokemon_name+".png"))
	opponent_frame.get_node("HpBar").max_value = opponent.get_pokemon().hp
	opponent_frame.get_node("HpBar").value = opponent.get_pokemon().current_hp
	opponent_frame.get_node("Lvl").text = "lvl "+str(opponent.get_pokemon().level)
	opponent_frame.get_node("Name").text = opponent.get_pokemon().pokemon_name

func battle_intro():
	get_player_pokemon_data(0)
	get_opponent_pokemon_data()
	opponent_pokemon.texture = opponent.battle_sprite
	battle_animation.play("start_fight")
	dialog_box._set_dialog_text(opponent.trainer_name+" would like to battle")
	yield(dialog_box,"dialog_finished")
	#yield(player,"next_key_pressed")
	battle_animation.play("opponent_switch")
	dialog_box._set_dialog_text(opponent.name+" send out "+opponent.get_pokemon().pokemon_name+" !")
	yield(battle_animation,"animation_finished")
	battle_animation.play("opponent_switch_pokemon")
	opponent_pokemon.texture = (load("res://Assets/Pokemon/"+opponent.get_pokemon().pokemon_name+".png"))
	yield(battle_animation,"animation_finished")
	battle_animation.play("player_switch")
	dialog_box._set_dialog_text("Go "+player.get_pokemon(0).pokemon_name+" !")
	yield(battle_animation,"animation_finished")
	battle_animation.play("player_switch_pokemon")
	player_pokemon.texture = (load("res://Assets/Pokemon/"+player.get_pokemon(0).pokemon_name+".png"))
	yield(battle_animation,"animation_finished")
	player_frame.show()
	opponent_frame.show()
	
	change_state(SELECT_ACTION)

func change_turn():
	moves_panel.hide()
	if player.get_pokemon(0).speed > opponent.get_pokemon().speed:
		first_pokemon = player.get_pokemon(0)
		change_state(PLAYER_TURN)
		
	elif opponent.get_pokemon().speed > player.get_pokemon(0).speed:
		first_pokemon = opponent.get_pokemon()
		change_state(OPPONENT_TURN)

func player_turn():
	dialog_box._set_dialog_text(player.get_pokemon(0).pokemon_name+" used "+player.get_pokemon(0).get_move(selection).move_name)
	yield(dialog_box,"dialog_finished")
	battle_animation.play("opponent_damage_taken")
	yield(battle_animation,"animation_finished")
	player.get_pokemon(0).attack(player.get_pokemon(0).get_move(selection),opponent.get_pokemon())
	_bar_animation(opponent_frame.get_node("HpBar"), opponent.get_pokemon().current_hp)
	yield(tween,"tween_completed")
	
	if(opponent.get_pokemon().dead()):
		change_state(OPPONENT_DEATH)
		
	elif first_pokemon == player.get_pokemon(0):
		change_state(OPPONENT_TURN)
		
	else:
		change_state(SELECT_ACTION)

func trainer_turn():
	dialog_box._set_dialog_text(opponent.get_pokemon().pokemon_name+" used "+opponent.choose_move().move_name)
	yield(dialog_box,"dialog_finished")
	battle_animation.play("player_damage_taken")
	yield(battle_animation,"animation_finished")
	opponent.get_pokemon().attack(opponent.choose_move(),player.get_pokemon(0))
	_bar_animation(player_frame.get_node("HpBar"),player.get_pokemon(0).current_hp)
	yield(tween,"tween_completed")
	
	if player.get_pokemon(0).dead():
		change_state(PLAYER_DEATH)
		
	elif first_pokemon == opponent.get_pokemon():
		change_state(PLAYER_TURN)
		
	else:
		change_state(SELECT_ACTION)

func player_pokemon_dead():
	dialog_box._set_dialog_text(player.get_pokemon(0).pokemon_name+" as fainted !")
	action_panel.hide()

func opponent_pokemon_dead():
	action_panel.hide()
	dialog_box._set_dialog_text(opponent.get_pokemon().pokemon_name+" as fainted !")
	opponent_pokemon.visible = false
	yield(dialog_box,"dialog_finished")
	#yield(dialog_box, "key_pressed")
	get_player_pokemon_data(0) #update exp bar 
	player.get_pokemon(0)._gain_experience(8000)
	dialog_box._set_dialog_text(player.get_pokemon(0).pokemon_name+" gained "+str(player.get_pokemon(0).experience_total)+" experiences")

	opponent_frame.hide()
	
	change_state(GAIN_EXPERIENCE)

func gain_experience():
	for i in range(player.get_pokemon(0).level_completed):
		if i < player.get_pokemon(0).level_completed - 1:
			_bar_animation(player_frame.get_node("ExpBar"),player.get_pokemon(0).experience_required)
			yield(tween,"tween_completed")
			player_frame.get_node("ExpBar").value = 0
			
		else:
			_bar_animation(player_frame.get_node("ExpBar"),player.get_pokemon(0).experience)
			yield(tween,"tween_completed")
	
	player_frame.get_node("Lvl").text = "lvl "+str(player.get_pokemon(0).level)
	yield(dialog_box,"dialog_finished")
	player.get_pokemon(0).reset_experience_total()
	
	if opponent.check_party_empty():
		change_state(OPPONENT_DEFEATED)
		
	else:
		change_state(OPPONENT_SWITCH)

func opponent_switch_pokemon():
	get_opponent_pokemon_data()
	dialog_box._set_dialog_text(opponent.trainer_name+" send out "+opponent.get_pokemon().pokemon_name)
	yield(dialog_box,"dialog_finished")
	battle_animation.play_backwards("opponent_switch_pokemon")
	yield(battle_animation,"animation_finished")
	opponent_pokemon.visible = true
	battle_animation.play("opponent_switch_pokemon")
	yield(battle_animation,"animation_finished")
	opponent_frame.show()
	action_panel.show()

func opponent_defeated():
	action_panel.hide()
	dialog_box._set_dialog_text("Congrulation you have beat ! "+opponent.trainer_name)
	yield(dialog_box,"dialog_finished")
	#yield(dialog_box,"key_pressed")
	queue_free()

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
	pass 

func _on_Move4_pressed():
	pass 

func on_BattleScene_state_changed():
	update_battle()

