extends CharacterBody2D

var basic_bolt = preload("res://player/basic_bolt.tscn")

@onready var main_thrust_particles: GPUParticles2D = $Pivot/MainThrustParticles
@onready var left_thrust_particles: GPUParticles2D = $Pivot/LeftThrustParticles
@onready var right_thrust_particles: GPUParticles2D = $Pivot/RightThrustParticles
@onready var forward_thrust_particles: GPUParticles2D = $Pivot/ForwardThrustParticles
@onready var rear_left_thrust_particles: GPUParticles2D = $Pivot/RearLeftThrustParticles
@onready var rear_right_thrust_particles: GPUParticles2D = $Pivot/RearRightThrustParticles

@onready var main_thrust_texture: TextureRect = $Pivot/MainThrust
@onready var left_thrust_texture: TextureRect = $Pivot/LeftThrust
@onready var right_thrust_texture: TextureRect = $Pivot/RightThrust
@onready var forward_thrust_texture: TextureRect = $Pivot/ForwardThrust
@onready var rear_left_thrust_texture: TextureRect = $Pivot/RearLeftThrust
@onready var rear_right_thrust_texture: TextureRect = $Pivot/RearRightThrust

@onready var main_cannon_marker: Marker2D = $Pivot/MainCannonMarker

@export var impulse_acceleration: float = 300.0
@export var impulse_break: float = impulse_acceleration;
@export var main_thrust_acceleration: float = 1000.0
const ANGULAR_SPEED := PI;
const MAX_SPEED := 2000.0;


func _physics_process(delta: float) -> void:
	var impulse: Vector2 = get_impulse()	
	var main_thrust: Vector2 = get_main_thrust()
	
	var impulse_on: bool = not impulse.is_zero_approx()
	var main_thrust_on: bool = not main_thrust.is_zero_approx()
	
	if main_thrust_on:
		main_thrust_texture.visible = true
		main_thrust_particles.emitting = true
	else:
		main_thrust_texture.visible = false
		main_thrust_particles.emitting = false
		
	var impulse_up := []
	var impulse_down := []
	var impulse_particles_up := []
	var impulse_particles_down := []
	if impulse_on:
		var bowToImpulse := (-transform.y).angle_to(impulse)
		var starboardToImpulse := (transform.x).angle_to(impulse)
		var base_tolerance := PI/2.0
		var fbdead = PI/6.0;
		var lrdead = PI/4.0;
		
		if abs(bowToImpulse) > base_tolerance + fbdead:
			impulse_up.append(forward_thrust_texture)
			impulse_particles_up.append(forward_thrust_particles)
		else:
			impulse_down.append(forward_thrust_texture)
			impulse_particles_down.append(forward_thrust_particles)
		
		if abs(starboardToImpulse) < base_tolerance - lrdead:
			impulse_up.append(left_thrust_texture)
			impulse_particles_up.append(left_thrust_particles)
		else:
			impulse_down.append(left_thrust_texture)
			impulse_particles_down.append(left_thrust_particles)
		
		if abs(starboardToImpulse) > base_tolerance + lrdead:
			impulse_up.append(right_thrust_texture)
			impulse_particles_up.append(right_thrust_particles)
		else:
			impulse_down.append(right_thrust_texture)
			impulse_particles_down.append(right_thrust_particles)
		
		if abs(bowToImpulse) < base_tolerance - fbdead:
			impulse_up.append(rear_left_thrust_texture)
			impulse_up.append(rear_right_thrust_texture)
			impulse_particles_up.append(rear_left_thrust_particles)
			impulse_particles_up.append(rear_right_thrust_particles)
		else:
			impulse_down.append(rear_left_thrust_texture)
			impulse_down.append(rear_right_thrust_texture)
			impulse_particles_down.append(rear_left_thrust_particles)
			impulse_particles_down.append(rear_right_thrust_particles)
			
	else:
		impulse_down.append(forward_thrust_texture)
		impulse_down.append(left_thrust_texture)
		impulse_down.append(right_thrust_texture)
		impulse_down.append(rear_left_thrust_texture)
		impulse_down.append(rear_right_thrust_texture)
		impulse_particles_down.append(forward_thrust_particles)
		impulse_particles_down.append(left_thrust_particles)
		impulse_particles_down.append(right_thrust_particles)
		impulse_particles_down.append(rear_left_thrust_particles)
		impulse_particles_down.append(rear_right_thrust_particles)
		
	for texture_rect in impulse_up:
		texture_rect.visible = true
	for texture_rect in impulse_down:
		texture_rect.visible = false
	for particles in impulse_particles_up:
		particles.emitting = true
	for particles in impulse_particles_down:
		particles.emitting = false
	
	if impulse_on or main_thrust_on:
		var impulse_reverse_multiplier: float = 2 if abs(impulse.angle_to(velocity)) > PI / 2 else 1
		velocity += impulse * impulse_acceleration * delta * impulse_reverse_multiplier
		velocity += main_thrust * main_thrust_acceleration * delta
	else:
		if velocity.length() < (impulse_break * delta):
			velocity = Vector2.ZERO
		else:
			var normalized_velocity = velocity.normalized()
			normalized_velocity *= - (impulse_break * delta)
			velocity += normalized_velocity
		
	var new_rotation : float = delta * ANGULAR_SPEED * get_rotation_impulse()
	rotate(new_rotation);
	
	velocity = velocity.min(Vector2(MAX_SPEED, MAX_SPEED)).max(Vector2(-MAX_SPEED, -MAX_SPEED))
	
	if Input.is_action_just_pressed("fire"):
		var bolt_instance = basic_bolt.instantiate()
		get_tree().root.add_child(bolt_instance)
		bolt_instance.shoot(main_cannon_marker.global_transform)

	move_and_slide()


func get_rotation_impulse() -> float:
	return Input.get_axis("rotate_ccw", "rotate_cw");


func get_impulse() -> Vector2:
	return Vector2(Input.get_axis("impulse_left", "impulse_right"), Input.get_axis("impulse_up", "impulse_down"));

func get_main_thrust() -> Vector2:
	return -transform.y * Input.get_action_strength("main_thrust")
