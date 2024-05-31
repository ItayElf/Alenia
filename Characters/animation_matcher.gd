extends Node
class_name AnimationMatcher

var animations: AnimationPlayer
var can_move: bool = true

func update_animation(last_direction: Vector2, current_direction: Vector2):
	if last_direction == Vector2.ZERO and current_direction == last_direction:
		return
		
	var direction := "front"
	var state = "move_"
	if current_direction == Vector2.ZERO or not can_move:
		state = "idle_"
		current_direction = last_direction
	
	if current_direction.x < 0: direction = "left"
	elif current_direction.x > 0: direction = "right"
	elif current_direction.y < 0: direction = "back"
	
	animations.play(state + direction)

