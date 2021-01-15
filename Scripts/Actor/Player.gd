extends KinematicBody2D

var speed 
var state = WALK
var current_direction
var party = Party.new()

onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")
onready var ray_cast = get_node("RayCast2D")
onready var animation_player = get_node("AnimationPlayer")
onready var interact_range = get_node("InteractRange")

const TILE_SIZE = 16
const WALK_SPEED = 0.5
const RUN_SPEED  = 0.2
const STOP_SPEED = 0

enum DIRECTION { UP, DOWN, LEFT, RIGHT }

enum {
	WALK,
	RUN,
	STOP
}

func _ready():
#	state = WALK
	sprite.frame = 4
	Global.align_object_with_grid(self)
	pokemon_team()

func _physics_process(delta):
	dialog_range()
	prevent_moving()
	match state:
		WALK:
			walk()
		RUN:
			run()
		STOP:
			speed = STOP_SPEED

"""
Verifie si la zone de dialogue qui suit le joueur entre en collision 
avec tout les objects du jeux qui contient la methode Interact()
"""
func dialog_range():
	if Input.is_action_just_pressed("ui_a"):
		for body in interact_range.get_overlapping_bodies():
			if body.has_method("interact"):
				body.interact()
				body.refacing(self)
				if body.status == body.STATUS.UNDEFEATED:
					body.start_fight()

func prevent_moving():
	if state != STOP:
		if back() == true:
			state = RUN
		elif back() == false:
			state = WALK

func move(direction):
	ray_cast.cast_to = direction * TILE_SIZE
	ray_cast.force_raycast_update()
	
	#check collison
	if !ray_cast.is_colliding():
			tween.interpolate_property(self,"position", position, position + direction * TILE_SIZE,
			speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()

func get_input(animation):
	if tween.is_active():
		return
		
	if Input.is_action_pressed("ui_up"):
		move(Vector2.UP)
		animation_player.play(animation+"_up")
		current_direction = DIRECTION.UP
		
	elif Input.is_action_pressed("ui_down"):
		move(Vector2.DOWN)
		animation_player.play(animation+"_down")
		current_direction = DIRECTION.DOWN
		
	elif Input.is_action_pressed("ui_left"):
		move(Vector2.LEFT)
		animation_player.play(animation+"_left")
		current_direction = DIRECTION.LEFT
		
	elif Input.is_action_pressed("ui_right"):
		move(Vector2.RIGHT)
		animation_player.play(animation+"_right")
		current_direction = DIRECTION.RIGHT

func walk():
	sprite.texture = (load("res://Assets/SpriteSheets/red_walking.png"))
	speed = WALK_SPEED
	get_input("walk")

func run():
	sprite.texture = (load("res://Assets/SpriteSheets/red_running.png"))
	speed = RUN_SPEED
	get_input("run")

func accept():
	if Input.is_action_just_pressed("ui_a"):
		return true
	elif Input.is_action_just_released("ui_a"):
		return false

func back():
	if Input.is_action_just_pressed("ui_s"):
		return true
	elif Input.is_action_just_released("ui_s"):
		return false

"""
Creation d'une équipe de pokemon pour le joueur
"""
func pokemon_team():
	var charizard = Pokemon.new("Charizard", 100, 78, 84, 78, 109, 85, 100)
	var flamethrower = Move.new("Flamethrower", 75, 100, "Fire", "Special", 10)
	var dragon_claw = Move.new("Dragon Claw", 60, 100, "Dragon", "Physical", 5)
	charizard.add_move(flamethrower)
	charizard.add_move(dragon_claw)
	
	var venusaur = Pokemon.new("Venusaur", 90, 80, 82, 83, 100, 100, 80 )
	var razor_leaf = Move.new("Razor Leaf", 55, 95, "Grass", "Physical", 25)
	var double_edge = Move.new("Double Edge", 120, 100, "Normal", "Physical",5)
	var earthquake = Move.new("Earthquake", 100, 100, "Ground", "Physical", 10)
	var sludge_bomb = Move.new("Sludge Bomb", 90, 100, "Poison", "Special", 10)
	
	venusaur.add_move(razor_leaf)
	venusaur.add_move(double_edge)
	venusaur.add_move(earthquake)
	venusaur.add_move(sludge_bomb)
	
	party.add_pokemon(venusaur)
	party.add_pokemon(charizard)
	
