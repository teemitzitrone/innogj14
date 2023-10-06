extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction :=  "down"

@onready var animation = $AnimationPlayer
var direction

func _ready():
	direction = starting_direction

func _physics_process(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	# updateAnimation() #ToDo add animation palyer

func updateAnimation():
	var prefix = "walk"
	if velocity == Vector2.ZERO:
		prefix = "idle"
		
	if velocity.x < 0: direction = "left"
	elif velocity.x > 0: direction = "right"
	elif velocity.y < 0: direction = "up"
	elif velocity.y > 0: direction = "down"
	
	# animation.play(prefix + "_" + direction)  #ToDo add animations to palyer
