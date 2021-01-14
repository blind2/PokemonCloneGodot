extends Node
class_name Move

var move_name
var power
var accuracy
var type
var category
var pp

var max_pp
var damage

func _init(move_name, power, accuracy, type, category, pp):
	self.move_name = move_name
	self.power = power
	self.accuracy = accuracy
	self.type = type
	self.category = category
	self.pp = pp
	self.max_pp = pp

