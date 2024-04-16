extends StaticBody2D
class_name Base

@export var win_lose_screen: PackedScene

@export var hp: int = 20 :
	set(val):
		hp = val
		if is_inside_tree():
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "modulate", Color.WHITE, 0.5).from(Color(1.3, 1.3, 1.3))
			if hp <= 0:
				die()

func die():
	$Polygon2D.visible = false
	$CollisionPolygon2D.set_deferred("disabled", true)
	
	$ExplosionParticles.emitting = true
	$ExplosionSFX.play()
	
	var camera: Camera2D = get_tree().get_first_node_in_group("camera")
	camera.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "global_position", global_position, 0.5)
	tween.tween_property(camera, "zoom", camera.zoom * 0.75, 5)
	
	await get_tree().create_timer(1).timeout
	add_child(win_lose_screen.instantiate())
