extends CharacterBody2D
class_name EnemyShip

@export var hp: int = 10 :
	set(val):
		hp = val
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(1.3, 1.3, 1.3))
		if hp <= 0:
			die()

@export var speed: float = 450
@export var rotation_speed: float = 5

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var projectile_shooter: EnemyProjectileShooter = $ProjectileShooter

var enemy_target: Node2D
var is_dead: bool

func _physics_process(delta: float):
	if is_dead:
		return
	
	chase_target(delta)
	
	move_and_slide()

func chase_target(delta: float):
	if enemy_target == null:
		return
	
	var target_rotation: float = global_position.angle_to_point(enemy_target.global_position) + PI/2
	global_rotation = lerp_angle(global_rotation, target_rotation, rotation_speed * delta)
	
	nav_agent.target_position = enemy_target.global_position
	
	if nav_agent.distance_to_target() > 500:
		var direction: Vector2 = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, delta * 5)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * 500)
	
	if nav_agent.distance_to_target() < 800:
		projectile_shooter.can_shoot = true
	else:
		projectile_shooter.can_shoot = false

func die():
	is_dead = true
	$ExplosionParticles.emitting = true
	$Sprite2D.visible = false
	$CollisionPolygon2D.set_deferred("disabled", true)
	$ProjectileShooter.process_mode = Node.PROCESS_MODE_DISABLED
	$ExplosionSFX.play()
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if enemy_target == null and body.is_in_group("friendly"):
		enemy_target = body
