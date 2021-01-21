extends Node
class_name Pokemon

var pokemon_name
var level
var type
var hp
var attack
var defense
var special_attack
var special_defense
var speed
var front_sprite
var back_sprite
var menu_sprite
var is_dead = false
var current_hp

var experience_total =  0
var experience = 0
var experience_required
var level_completed = 0

var list_of_moves = []

func _init(level, pokemon):
	#information sur le pokemon
	self.level = level
	pokemon_name = pokemon["name"]
	type = pokemon["type"]
	front_sprite = pokemon["front_sprite"]
	back_sprite = pokemon["back_sprite"]
	menu_sprite = pokemon["menu_sprite"]
	
	#pokemon stats
	hp = get_stat(pokemon["base_hp"], hp)
	attack = get_stat(pokemon["base_attack"], attack)
	defense = get_stat(pokemon["base_defense"], defense)
	special_attack = get_stat(pokemon["base_special_attack"], special_attack)
	special_defense = get_stat(pokemon['base_special_defense'], special_defense)
	speed = get_stat(pokemon["base_speed"], speed)
	
	current_hp = hp
	experience_required = get_required_experience()

func get_stat(base_stat, stat):
	stat =  base_stat + level * 2
	return stat

func add_move(new_move):
	list_of_moves.append(new_move)

func get_amount_of_experience(opponent_pokemon):
	return round (pow(opponent_pokemon.level,1.8))

func gain_experience(amount):
	experience_total += amount
	experience += amount
	
	while experience >= experience_required:
		experience -= experience_required
		level_completed+=1
		_lvl_up()

func reset_experience_total():
	experience_total = 0

func _lvl_up():
	level += 1
	experience_required = get_required_experience()
	print(level)

func get_required_experience():
	return round (pow(level,1.8) + level * 4)

func attack(move, pokemon):
	if pokemon.current_hp>0:
		var damage =((level*2/5) * (move.power*attack/pokemon.defense))/50
		pokemon.current_hp -= damage

func dead():
	if current_hp <=0:
		return true
	else:
		return false

func get_move(move_index):
	if move_index < list_of_moves.size():
		return list_of_moves[move_index]
