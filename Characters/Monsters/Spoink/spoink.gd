extends CharacterBody2D

@export var speed := 20

@onready var animations := $AnimationPlayer
@onready var animation_matcher := AnimationMatcher.new()

var current_direction := Vector2.ZERO
var direction_timer: Timer

func get_movement_direction() -> Vector2:
	var directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.ZERO
	]
	var random_direction = directions[randi() % directions.size()]
	return random_direction

func _set_up_timer():
	direction_timer = Timer.new()
	direction_timer.connect("timeout", _on_timer_end)
	add_child(direction_timer)
	_on_timer_end()

func _on_timer_end():
	direction_timer.wait_time = randi() % 2 + 2
	current_direction = get_movement_direction()
	direction_timer.start()

func _ready():
	animation_matcher.animations = animations
	animations.play("idle_front")
	_set_up_timer()


func _physics_process(delta):
	var last_direction := Vector2i(velocity / speed)
	var move_direction := current_direction
	velocity = move_direction * speed
	
	move_and_slide()
	
	animation_matcher.update_animation(last_direction, move_direction)
