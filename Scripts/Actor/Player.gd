extends KinematicBody2D

var speed 
var state = WALK
var party = Party.new()
var player_input = PlayerInput.new()

onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")
onready var ray_cast = get_node("RayCast2D")
onready var animation_player = get_node("AnimationPlayer")

const TILE_SIZE = 16
const WALK_SPEED = 0.5
const RUN_SPEED  = 0.2

var inputs = {
	"ui_up": Vector2.UP,
	"ui_down" : Vector2.DOWN,
	"ui_left" : Vector2.LEFT,
	"ui_right" : Vector2.RIGHT
}

enum {
	WALK,
	RUN,
}

func _ready():
	sprite.frame = 4
	position = position.snapped(Vector2.ONE * TILE_SIZE) 
	position += Vector2.ONE * TILE_SIZE/2 
	pokemon_team()

func _physics_process(delta):
	player_input.update()
	
	if player_input.back() == true:
		state = RUN
	elif player_input.back() == false:
		state = WALK

	match state:
		WALK:
			walk()
		RUN:
			run()

func move(direction):
	ray_cast.cast_to = inputs[direction] * TILE_SIZE
	ray_cast.force_raycast_update()
	
	#check collison
	if !ray_cast.is_colliding():
			tween.interpolate_property(self,"position", position, position + inputs[direction] * TILE_SIZE,
			speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()

func get_direction(animation):
	if tween.is_active():
		return
		
	if player_input.input == player_input.UP:
		move("ui_up")
		animation_player.play(animation+"_up")
		
	elif player_input.input == player_input.DOWN:
		move("ui_down")
		animation_player.play(animation+"_down")
		
	elif player_input.input == player_input.LEFT:
		move("ui_left")
		animation_player.play(animation+"_left")
		
	elif player_input.input == player_input.RIGHT:
		move("ui_right")
		animation_player.play(animation+"_right")

func walk():
	sprite.texture = (load("res://Assets/SpriteSheets/red_walking.png"))
	speed = WALK_SPEED
	get_direction("walk")

func run():
	sprite.texture = (load("res://Assets/SpriteSheets/red_running.png"))
	speed = RUN_SPEED
	get_direction("run")


func pokemon_team():
	var charizard = Pokemon.new("Charizard", 50, 78, 84, 78, 109, 85, 100)
	var flamethrower = Move.new("Flamethrower", 75, 100, "Fire", "Special", 10)
	var dragon_claw = Move.new("Dragon Claw", 60, 100, "Dragon", "Physical", 5)
	charizard.add_move(flamethrower)
	charizard.add_move(dragon_claw)
	
	var venusaur = Pokemon.new("Venusaur", 50, 80, 82, 83, 100, 100, 80 )
	var razor_leaf = Move.new("Razor Leaf", 55, 95, "Grass", "Physical", 25)
	venusaur.add_move(razor_leaf)
	
	party.add_pokemon(charizard)
	party.add_pokemon(venusaur)
