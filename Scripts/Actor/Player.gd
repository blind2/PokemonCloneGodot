extends KinematicBody2D

var speed 
var state = WALK
var current_direction
var party = Party.new()
var can_interact = true
var battle_scene = preload("res://Scenes/Screen/BattleScene.tscn")
var is_battling = false

onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")
onready var ray_cast = get_node("RayCast2D")
onready var animation_player = get_node("AnimationPlayer")
onready var interact_range = get_node("InteractRange")
onready var dialog_box = get_node("/root/World/GameUI/DialogBox")
onready var game_ui = get_node("/root/World/GameUI")

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

func dialog_range():
	if accept(): # touche "a"
		for body in interact_range.get_overlapping_bodies():
			if body.has_method("interact"):
				state = STOP
				body.interact()
				body.refacing(self)
				yield(dialog_box,"dialog_finished")
				if body.status == body.STATUS.UNDEFEATED and is_battling == false:
					body.can_talk = false
					start_battle(body)
				elif body.status == body.STATUS.DEFEATED:
					state = WALK

func start_battle(opponent):
	is_battling = true
	SceneChanger.battle_transition()
	yield(SceneChanger,"scene_changed")
	var new_battle_scene = battle_scene.instance()
	new_battle_scene.create_battle_scene(self, opponent)
	game_ui.add_child(new_battle_scene)
	

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
	if Input.is_action_just_pressed("ui_a") and can_interact == true:
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
	var charizard = Pokemon.new(50, PokemonData.charizard)
	var flamethrower = Move.new(MoveData.flamethrower)
	var dragon_claw = Move.new(MoveData.dragon_claw)
	
	charizard.add_move(flamethrower)
	charizard.add_move(dragon_claw)
	
	var venusaur = Pokemon.new(90, PokemonData.venusaur)
	var razor_leaf = Move.new(MoveData.razor_leaf)
	var double_edge = Move.new(MoveData.double_edge)
	var earthquake = Move.new(MoveData.earthquake)
	var sludge_bomb = Move.new(MoveData.sludge_bomb)
	
	venusaur.add_move(razor_leaf)
	venusaur.add_move(double_edge)
	venusaur.add_move(earthquake)
	venusaur.add_move(sludge_bomb)
	
	party.add_pokemon(venusaur)
	party.add_pokemon(charizard)
	
