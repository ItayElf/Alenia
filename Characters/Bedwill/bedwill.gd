extends CharacterBody2D
class_name Player

@export var speed := 35

@onready var animations := $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var animation_matcher := AnimationMatcher.new()

signal health_changed

const KNOCKBACK_DURATION = 0.25

var can_move := true
var max_health := 3.0
var current_health := max_health
var knockback_velocity := Vector2.ZERO
var knockback_tween: Tween

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
	velocity = move_direction * speed + knockback_velocity
	
	if can_move:
		move_and_slide()
	
	animation_matcher.can_move = can_move
	animation_matcher.update_animation(move_direction)

func damage_modulate():
	sprite.modulate = Color(1, 0, 0, 1)
	knockback_tween.parallel().tween_property(sprite, "modulate", Color(1,1,1,1), KNOCKBACK_DURATION)

func knockback(enemy_velocity: Vector2, power: int):
	var knock_direction = (enemy_velocity - velocity).normalized() * power
	knockback_velocity = knock_direction

	knockback_tween = get_tree().create_tween()
	knockback_tween.parallel().tween_property(self, "knockback_velocity", Vector2.ZERO, KNOCKBACK_DURATION)

func _on_hurtbox_area_entered(area):
	current_health = max(0, current_health - 0.5)
	health_changed.emit(current_health)
	knockback(area.get_parent().velocity, 150)
	damage_modulate()
