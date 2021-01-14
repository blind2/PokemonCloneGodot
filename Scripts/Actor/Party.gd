extends Node
class_name Party

var current_pokemon = 0
var list_of_pokemon = []

func add_pokemon(pokemon):
	list_of_pokemon.append(pokemon)

func remove_pokemon(pokemon):
	list_of_pokemon.remove(pokemon)

func check_party_empty():
	var next_pokemon = current_pokemon + 1
	
	#le dresseur lui reste encore des pokemons
	if next_pokemon<list_of_pokemon.size():
		current_pokemon = list_of_pokemon[next_pokemon]
		return false
	else:
		#le dresseur n'a plus de pokemon
		return true
	
func get_pokemon():
	return list_of_pokemon[current_pokemon]
