extends PokemonBaseStats
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

var is_dead = false
var current_hp
var experience_total =  0
var experience = 0
var experience_required = _get_required_experience(level)
var level_completed = 0
var list_of_moves = []

func _init(pokemon_name, level, base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed).(base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed):
	self.pokemon_name = pokemon_name
	self.level = level
	self.hp = get_stat(base_hp, hp)
	self.attack = get_stat(base_attack, attack)
	self.defense = get_stat(base_defense, defense)
	self.special_attack = get_stat(base_special_attack, special_attack)
	self.special_defense = get_stat(base_special_defense, special_defense)
	self.speed = get_stat(base_speed, speed)
	current_hp = hp
	

#Calcule la statistique du pokemon selon la stat de base
func get_stat(base_stat, stat):
	stat =  base_stat + level * 2
	return stat

func add_move(new_move):
	list_of_moves.append(new_move)

func _gain_experience(amount):
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
	experience_required = _get_required_experience(level)
	print(level)
	

func _get_required_experience(lvl):
	return round (pow(lvl,1.8) + lvl * 4)

func attack(move, pokemon):
	if pokemon.current_hp>0:
		var damage =((level*2/5) * (move.power*attack/pokemon.defense))/50
		pokemon.current_hp -= damage
		print(move.move_name+" dealt "+str(damage)+" damage")

func dead():
	if current_hp <=0:
		return true
	else:
		return false

func get_move(move_index):
	return list_of_moves[move_index]

