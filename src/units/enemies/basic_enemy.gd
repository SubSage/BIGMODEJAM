extends CharacterBody2D


var speed = 300.0
var direction = Vector2(1.0, 0).normalized()


func _physics_process(delta):

	velocity = direction * speed
	move_and_slide()


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
