extends Node2D

@export var spawned: PackedScene

@onready var animation = $AnimationPlayer

var _instance: CharacterBody2D

func _ready():
	animation.play("spawn")
	_instance = spawned.instantiate()
	self.scale = _instance.scale


func _on_animation_player_animation_finished(_anim_name):
	_instance.global_position = self.global_position
	get_parent().add_child(_instance)
	queue_free()
