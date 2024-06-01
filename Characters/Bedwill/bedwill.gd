extends CharacterBody2D
class_name Player

@export var speed := 35

@onready var animations := $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var animation_matcher := AnimationMatcher.new()

var can_move := true
var max_health := 3.0
var current_health := max_health

func get_global_center_position() -> Vector2:
	return global_position + sprite.position

func clamp_to_limits(limit_position: Vector2, limit_size: Vector2):
	global_position.x = clamp(global_position.x, limit_position.x + 8, limit_position.x + limit_size.x - 8)
	global_position.y = clamp(global_position.y, limit_position.y + 16, limit_position.y + limit_size.y)

func get_movement_direction() -> Vector2:
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		move_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	elif Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
		move_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return move_direction.normalized()

func _ready():
	animation_matcher.animations = animations
	animations.play("idle_front")

func _physics_process(_delta):
	var move_direction := get_movement_direction()
	velocity = move_direction * speed
	
	if can_move:
		move_and_slide()
	
	animation_matcher.can_move = can_move
	animation_matcher.update_animation(move_direction)


func _on_hurtbox_area_entered(area):
	current_health -= 0.5
	print_debug(current_health)
