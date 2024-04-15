extends StaticBody2D
class_name Base

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
