extends CharacterBody2D

@export var speed := 35

@onready var animations := $AnimationPlayer

func get_movement_direction() -> Vector2:
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		move_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	elif Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
		move_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return move_direction.normalized()

func update_animation(last_direction: Vector2, current_direction: Vector2):
	if last_direction == Vector2.ZERO and current_direction == last_direction:
		return
		
	var direction := "front"
	var state = "move_"
	if current_direction == Vector2.ZERO:
		state = "idle_"
		current_direction = last_direction
	
	if current_direction.x < 0: direction = "left"
	elif current_direction.x > 0: direction = "right"
	elif current_direction.y < 0: direction = "back"
	
	animations.play(state + direction)

func _ready():
	animations.play("idle_front")

func _physics_process(delta):
	var last_direction := Vector2i(velocity / speed)
	var move_direction := get_movement_direction()
	velocity = move_direction * speed
	move_and_slide()
	update_animation(last_direction, move_direction)
