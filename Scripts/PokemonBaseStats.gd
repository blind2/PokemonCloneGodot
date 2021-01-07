extends Node
class_name PokemonBaseStats

var base_hp
var base_attack
var base_defense
var base_special_attack
var base_special_defense
var base_speed

func _init(base_hp, base_attack, base_defense, base_special_attack, base_special_defense, base_speed):
	self.base_hp = base_hp
	self.base_attack = base_attack
	self.base_defense = base_defense
	self.base_special_attack = base_special_attack
	self.base_special_defense = base_special_defense
	self.base_speed = base_speed


