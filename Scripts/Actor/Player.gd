extends KinematicBody2D

var speed = 0.5
var state = WALK
var list_of_pokemon = []
var current_pokemon

onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")
onready var ray_cast = get_node("RayCast2D")
onready var animation_player = get_node("AnimationPlayer")

const TILE_SIZE = 16

var inputs = {
	"ui_up": Vector2.UP,
	"ui_down" : Vector2.DOWN,
	"ui_left" : Vector2.LEFT,
	"ui_right" : Vector2.RIGHT
}

enum {
	WALK,
	RUN,
	STOP
}

func _ready():
	sprite.frame = 4
	position = position.snapped(Vector2.ONE * TILE_SIZE) 
	position += Vector2.ONE * TILE_SIZE/2 
	_player_pokemon_team()

func _physics_process(delta):
	match state:
		WALK:
			walk()
		RUN:
			run()
		STOP:
			speed = 0
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			state = RUN
		elif !event.pressed and event.scancode == KEY_SPACE:
			state = WALK
		elif event.pressed and event.scancode == KEY_A:
			state = STOP

func move(direction):
	ray_cast.cast_to = inputs[direction] * TILE_SIZE
	ray_cast.force_raycast_update()
	
	#check collison
	if !ray_cast.is_colliding():
			tween.interpolate_property(self,"position", position, position + inputs[direction] * TILE_SIZE,
			speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	

func get_input(animation):
	if tween.is_active():
		return
		
	if Input.is_action_pressed("ui_up"):
		move("ui_up")
		animation_player.play(animation+"_up")
		
	elif Input.is_action_pressed("ui_down"):
		move("ui_down")
		animation_player.play(animation+"_down")
		
	elif Input.is_action_pressed("ui_left"):
		move("ui_left")
		animation_player.play(animation+"_left")
		
	elif Input.is_action_pressed("ui_right"):
		move("ui_right")
		animation_player.play(animation+"_right")

func walk():
	sprite.texture = (load("res://Assets/SpriteSheets/red_walking.png"))
	speed = 0.5
	get_input("walk")

func run():
	sprite.texture = (load("res://Assets/SpriteSheets/red_running.png"))
	speed= 0.2
	get_input("run")

func _add_pokemon(pokemon):
	list_of_pokemon.append(pokemon)

func get_pokemon(pokemon_index):
	return list_of_pokemon[pokemon_index]

#create a pokemon team for the player
func _player_pokemon_team():
	var charizard = Pokemon.new("Charizard",50,78,84,78,109,85,100)
	var flamethrower = Move.new("Flamethrower",75,100,"Fire","Special",10)
	var dragon_claw = Move.new("Dragon Claw",60,100,"Dragon","Physical",5)
	charizard.add_move(flamethrower)
	charizard.add_move(dragon_claw)
	_add_pokemon(charizard)
