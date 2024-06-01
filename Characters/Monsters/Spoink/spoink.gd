extends CharacterBody2D

@export var speed := 20

@onready var animations := $AnimationPlayer
@onready var animation_matcher := AnimationMatcher.new()

var wanderer: Wanderer

func _ready():
	wanderer = Wanderer.new()
	add_child(wanderer)
	wanderer.init()
	wanderer.enable()
	
	animation_matcher.animations = animations
	animations.play("idle_front")


func _physics_process(_delta):
	var last_direction := Vector2i(velocity / speed)
	var move_direction := wanderer.current_direction
	velocity = move_direction * speed
	
	move_and_slide()
	
	animation_matcher.update_animation(last_direction, move_direction)
