extends Node
class_name Knockbacker

const KNOCKBACK_DURATION = 0.25

var knockback_velocity := Vector2.ZERO
var should_modulate_sprite := true

var object: CharacterBody2D
var sprite: Sprite2D

var _knockback_tween: Tween

func _sprite_damage_modulate():
	sprite.modulate = Color(1, 0, 0, 1)
	_knockback_tween.parallel().tween_property(sprite, "modulate", Color(1,1,1,1), KNOCKBACK_DURATION)

func knockback(enemy_velocity: Vector2, power: int):
	var knock_direction = (enemy_velocity - object.velocity).normalized() * power
	knockback_velocity = knock_direction

	_knockback_tween = object.get_tree().create_tween()
	_knockback_tween.parallel().tween_property(self, "knockback_velocity", Vector2.ZERO, KNOCKBACK_DURATION)
	
	if should_modulate_sprite:
		_sprite_damage_modulate()
