extends CharacterBody2D


var speed = 300.0
var direction = Vector2(1.0, 0).normalized()
var health = 1

func _physics_process(delta):
	var player_scan = $player_scanner.get_overlapping_areas()
	var player
	if player_scan.size() > 0:
		player = player_scan[0]
	if is_instance_valid(player):
		if global_position.distance_to(player.global_position) > 12:
			direction = global_position.direction_to(player.global_position)
		else:
			player.get_parent().damage(1 * delta)
	else:
		direction = Vector2.ZERO
		
	velocity = direction * speed
	move_and_slide()

	
func damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
