extends CharacterBody2D


@export var clean_speed = 600.0
@export var combat_speed = 200.0

enum mode_enum {clean, combat}
var mode = mode_enum.clean
var suction_radius_min = 32
var suction_radius_max = 128
var dash_speed = 0
var dash_speed_max = 3200
var dash_reduction = dash_speed_max * 3
var radius_indicator_min = .25
var radius_indicator_max = 1.0

var ammo = 0

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var fire_strength = Input.get_action_strength("fire")
	
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
	
	$radius_indicator.rotate(.5*delta)
	move_and_slide()


func _on_vacuum_area_area_entered(area):
	if area.owner is Debris:
		area.owner.collected()
		ammo += 1
