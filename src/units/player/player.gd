extends CharacterBody2D


@export var clean_speed = 600.0
@export var combat_speed = 200.0

enum mode_enum {clean, combat}
var mode = mode_enum.clean
var suction_radius_min = 32
var suction_radius_max = 128
var dash_speed = 0
var dash_speed_max = 3200
var dash_reduction = dash_speed_max * 6
#var dash_reduction = dash_speed_max * 3
var radius_indicator_min = .25
var radius_indicator_max = 1.0
var rotation_speed = .5
var health = 2
var ammo = 0
const BULLET_CLASS = preload("res://units/bullet/bullets.tscn")
@onready var projectile_holder = get_tree().root.find_child("projectiles", true, false)
var last_fire_direction = Vector2(1.0, 0.0)

#func _ready():
	#print(projectile_holder)
	
func _physics_process(delta):
	$Label.text = str(health)
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var shoot_direction = Input.get_vector("shoot_left","shoot_right","shoot_up","shoot_down")
	var fire_strength = Input.get_action_strength("fire")
	
	if direction.length() > .1:
		animate(direction)
		
	if shoot_direction.length() > .1:
		last_fire_direction = shoot_direction
	
	dash_speed -= dash_reduction * delta
	dash_speed = clamp(dash_speed, 0, dash_speed_max)
	
	if Input.is_action_just_pressed("dash"):
		dash_speed = dash_speed_max
	
	
	if Input.is_action_just_pressed("switch_mode"):
		if mode == mode_enum.clean:
			mode = mode_enum.combat
		else:
			mode = mode_enum.clean
		
	
	match(mode):
		mode_enum.clean:
			velocity = direction * (clean_speed + dash_speed) * (1 - fire_strength / 2)
			$vacuum_area/CollisionShape2D.shape.radius = lerp(suction_radius_min, suction_radius_max, fire_strength)
			$radius_indicator.scale = Vector2.ONE * lerp(radius_indicator_min, radius_indicator_max, fire_strength)
	
		mode_enum.combat:
			velocity = direction * combat_speed
			if fire_strength > .1:
				var bullet = BULLET_CLASS.instantiate()
				bullet.direction = last_fire_direction.normalized()
				bullet.make_friendly()
				bullet.global_position = global_position
				projectile_holder.add_child(bullet)
	
	$radius_indicator.rotate(rotation_speed * delta)
	move_and_slide()


func _on_vacuum_area_area_entered(area):
	if area.owner is Debris:
		area.owner.collected()
		ammo += 1

func animate(direction):
#	pointing right is 0 degress screendownward is 90 deg
	var orientation = (snapped(rad_to_deg(direction.angle()), 45)/45) as int
	match orientation:
		0:
			$visual.play("right")
			$visual.flip_h = false
		1:
			$visual.play("down_right")
			$visual.flip_h = false
		2:
			$visual.play("down")
			$visual.flip_h = false
		3:
			$visual.play("down_right")
			$visual.flip_h = true
		4:
			$visual.play("right")
			$visual.flip_h = true
		-1:
			$visual.play("up_right")
			$visual.flip_h = false
		-2:
			$visual.play("up")
			$visual.flip_h = false
		-3:
			$visual.play("up_right")
			$visual.flip_h = true
	
	
func damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
