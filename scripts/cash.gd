extends RigidBody2D


var SPEED = 500.0
var slowSpeed = 10
const JUMP_VELOCITY = -400.0
var target
var value = 1

@onready var money_shadow: Sprite2D = $moneyShadow
@onready var money_actual: Sprite2D = $moneyActual

func _physics_process(delta: float) -> void:
	money_shadow.set_global_rotation_degrees(0)
	money_shadow.set_global_scale(Vector2(0.75,0.75))
	if target != null:
		apply_force(global_position.direction_to(target.global_position) * SPEED)
		SPEED += 10
	
func pickupAnimation():
	var tween = create_tween()
	
	tween.parallel().tween_property(money_shadow, "modulate:a", 0,.0)	
	tween.parallel().tween_property(money_actual, "rotation_degrees", 360, .65).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(money_actual, "scale", Vector2(1.55,1.55), .15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(money_actual, "scale", Vector2(0,0), .35).set_delay(0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(money_actual, "rotation_degrees", 0, 0).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	call_deferred("free")
