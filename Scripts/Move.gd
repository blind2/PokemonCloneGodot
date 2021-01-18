extends Node
class_name Move

var move_name
var power
var accuracy
var type
var pp

var max_pp
var damage

func _init(move):
	self.move_name = move["name"]
	self.power = move["power"]
	self.accuracy = move["accuracy"]
	self.type = move["type"]
	self.pp = move["pp"]
	self.max_pp = pp

