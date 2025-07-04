extends RigidBody2D

var SPEED = 500.0
var slowSpeed = 10
const JUMP_VELOCITY = -400.0
var target
var value = 5

@onready var money_actual: Sprite2D = $moneyActual
@onready var money_shadow: Sprite2D = $MoneyShadow

func _physics_process(delta: float) -> void:
	money_shadow.set_global_rotation_degrees(0)
	money_shadow.set_global_scale(Vector2(0.75,0.75))
	if target != null:
		apply_force(global_position.direction_to(target.global_position) * SPEED)
		SPEED += 10
		
func pickupAnimation():
	var tween = create_tween()
	money_shadow.visible = false
	
	tween.parallel().tween_property(money_shadow, "scale", Vector2(0,0),.25)
	tween.parallel().tween_property(money_actual, "rotation_degrees", 360, .65).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(money_actual, "scale", Vector2(1.55,1.55), .15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(money_actual, "scale", Vector2(0,0), .35).set_delay(0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(money_actual, "rotation_degrees", 0, 0).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	visible = false
	call_deferred("free")
