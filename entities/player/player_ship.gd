extends Entity
class_name Player


var basic_bolt = preload("res://entities/player/basic_bolt.tscn")


@export var base_impulse_tolerance := PI/2.0
@export var front_back_impulse_deadzone: float = PI/6.0
@export var left_right_impulse_deadzone: float = PI/4.0

@onready var main_thruster_sprite: Sprite2D = $Pivot/Thrusters/MainThrusterSprite
@onready var main_thruster_particles: GPUParticles2D = $Pivot/ThrusterParticles/MainThrusterParticles

@onready var thrusters: Array = [
	$Pivot/Thrusters/RearLeftImpulseSprite,
	$Pivot/Thrusters/RearRightImpulseSprite,
	$Pivot/Thrusters/LeftImpulseSprite,
	$Pivot/Thrusters/RightImpulseSprite,
	$Pivot/Thrusters/ForwardImpulseSprite,
]

@onready var thruster_predicates: Array = [
	func(impulse_on: bool, bowToImpulse: float, starboardToImpulse: float): 
		return impulse_on && abs(bowToImpulse) < base_impulse_tolerance - front_back_impulse_deadzone,
	func(impulse_on: bool, bowToImpulse: float, starboardToImpulse: float): 
		return impulse_on && abs(bowToImpulse) < base_impulse_tolerance - front_back_impulse_deadzone,
	func(impulse_on: bool, bowToImpulse: float, starboardToImpulse: float): 
		return impulse_on && abs(starboardToImpulse) < base_impulse_tolerance - left_right_impulse_deadzone,
	func(impulse_on: bool, bowToImpulse: float, starboardToImpulse: float): 
		return impulse_on && abs(starboardToImpulse) > base_impulse_tolerance + left_right_impulse_deadzone,
	func(impulse_on: bool, bowToImpulse: float, starboardToImpulse: float): 
		return impulse_on && abs(bowToImpulse) > base_impulse_tolerance + front_back_impulse_deadzone
]

@onready var shield: JellyShield = $Shield
@export var min_jelly_speed: float = 750.

@onready var main_cannon_marker: Marker2D = $Pivot/MainCannonMarker

@export var impulse_acceleration: float = 500.0
@export var drag: float = 150.0
@export var handling_multiplier: float = 3.0
@export var main_thrust_acceleration: float = 1500.0
@export var max_speed := 1000.0

@export var max_angular_velocity := 2.5*PI
@export var angular_impulse_acceleration := 6.*PI
@export var angular_velocity := 0.
@export var angular_drag := angular_impulse_acceleration

var primary_weapon_cooldown := 0.0


func _ready() -> void:
	super()
	if has_node("Camera2D"):
		$Camera2D.player = self


func _physics_process(delta: float) -> void:
	super(delta)
	var impulse: Vector2 = get_impulse()
	var main_thrust: Vector2 = get_main_thrust() * get_facing()
	
	var impulse_on: bool = not impulse.is_zero_approx()
	var main_thrust_on: bool = not main_thrust.is_zero_approx()
	
	# Main Thrust visuals
	if main_thrust_on:
		GlobalSignals.camera_shake_requested.emit(0.2, 250)
		main_thruster_sprite.visible = true
		main_thruster_particles.emitting = true
	else:
		main_thruster_sprite.visible = false
		main_thruster_particles.emitting = false
	
	# Impulse Thruster Visuals
	var bowToImpulse := get_global_facing().angle_to(impulse)
	var starboardToImpulse := (global_transform.x).angle_to(impulse)
	for i in thrusters.size():
		if thruster_predicates[i].call(impulse_on, bowToImpulse, starboardToImpulse):
			thrusters[i].visible = true
		else:
			thrusters[i].visible = false
	
	
	# General Velocity
	if impulse_on or main_thrust_on:
		var impulse_velocity = impulse * impulse_acceleration * delta
		var main_thrust_velocity = main_thrust * main_thrust_acceleration * delta
		var velocity_to_apply = impulse_velocity + main_thrust_velocity
		if (sign(velocity_to_apply.x) != sign(velocity.x)):
			velocity_to_apply.x *= handling_multiplier
		if (sign(velocity_to_apply.y) != sign(velocity.y)):
			velocity_to_apply.y *= handling_multiplier
		velocity += velocity_to_apply
	elif !velocity.is_zero_approx() :
		if velocity.length() < (drag * delta):
			velocity = Vector2.ZERO
		else:
			var normalized_velocity = velocity.normalized()
			normalized_velocity *= - (drag * delta)
			velocity += normalized_velocity
		
	# Angular Velocity
	var rotation_impulse := get_rotation_impulse()
	if (is_zero_approx(rotation_impulse)):
		angular_velocity = lerp(angular_velocity, 0., delta * angular_drag);
	else:
		var rotation_velocity_delta = delta * angular_impulse_acceleration * rotation_impulse
		angular_velocity += rotation_velocity_delta
	
	if !is_zero_approx(angular_velocity):
		angular_velocity = clampf(angular_velocity, -max_angular_velocity, max_angular_velocity)
		rotate(angular_velocity * delta)
	
	# Jelly Shield
	if !shield.jelly_vector.is_zero_approx():
		var jelly_vector : Vector2 = shield.jelly_vector.rotated(rotation)
		var theta_delta = jelly_vector.angle_to(velocity)
		if abs(theta_delta) > PI / 2 and velocity.length() > min_jelly_speed:
			var jellied_velocity : Vector2 = velocity.project(jelly_vector).rotated(PI)
			velocity += jellied_velocity / min(4., 2000. / velocity.length())
	
	# Velocity Cap
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# Fire
	if Input.is_action_pressed("fire") and primary_weapon_cooldown <= 0.0:
		var bolt_instance = basic_bolt.instantiate()
		primary_weapon_cooldown = bolt_instance.cooldown
		get_tree().root.add_child(bolt_instance)
		bolt_instance.shoot(main_cannon_marker.global_transform)
	
	# Maintain Timers
	if primary_weapon_cooldown > 0.0:
		primary_weapon_cooldown -= delta

	# Never forget
	move_and_slide()


func get_rotation_impulse() -> float:
	return Input.get_axis("rotate_ccw", "rotate_cw")


func get_impulse() -> Vector2:
	return Vector2(Input.get_axis("impulse_left", "impulse_right"), Input.get_axis("impulse_up", "impulse_down"))


func get_main_thrust() -> float:
	return Input.get_action_strength("main_thrust")


func get_facing() -> Vector2:
	return -transform.y


func get_global_facing() -> Vector2:
	return -global_transform.y


func speed_normalized() -> float:
	return velocity.length() / max_speed
