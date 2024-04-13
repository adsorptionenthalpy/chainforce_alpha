extends Node2D
class_name EnemyProjectileShooter

var projectile_scene: PackedScene = preload("res://Scenes/ShipProjectile/ship_projectile.tscn")

@onready var cooldown_timer: Timer = $Timer
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX
@onready var enemy_ship: CharacterBody2D = get_parent()

var can_shoot: bool # gets set to false when target is too far away

func shoot_projectile() -> void:
	if !can_shoot:
		return
	
	shoot_sfx.pitch_scale = randf_range(0.8, 1)
	shoot_sfx.play()
	var projectile: ShipProjectile = projectile_scene.instantiate()
	projectile.global_rotation = global_rotation
	projectile.global_position = global_position
	# Make the projectile "Evil"
	projectile.modulate = Color.ORANGE_RED
	projectile.get_node("ProjectileTrail").modulate = Color.ORANGE_RED
	projectile.set_collision_layer_value(2, false)
	projectile.set_collision_layer_value(3, true)
	projectile.set_collision_mask_value(2, true)
	projectile.set_collision_mask_value(3, false)
	enemy_ship.add_sibling(projectile)

func _on_timer_timeout() -> void:
	if enemy_ship.enemy_target != null:
		shoot_projectile()
