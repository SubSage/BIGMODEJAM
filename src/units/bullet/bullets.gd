extends Node2D
class_name BULLET
var direction = Vector2(1.0, 0.0)
var speed = 300
var damage = 1



func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	print(area, area.get_parent())
	area.get_parent().damage(damage)
	queue_free()

func make_friendly():
	$Area2D.set_collision_mask_value(3, true)
	
func make_enemy():
	$Area2D.set_collision_mask_value(2, true)
