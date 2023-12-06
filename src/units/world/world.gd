extends Node2D

@onready var player_ref = $player

func _process(delta):

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	if not is_instance_valid(player_ref) or player_ref.is_queued_for_deletion():
		get_tree().reload_current_scene()
