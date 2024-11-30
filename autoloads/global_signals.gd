extends Node


signal camera_shake_requested(duration: float, strength: float)

signal hitstop_requested(hitstop_time_ms: float)

signal ping_obstacle(obstacle_name: String)

signal projectile_spawn_requested(projectile: Projectile)
