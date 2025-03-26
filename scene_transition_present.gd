extends Control

@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animateFloat(animated_sprite_2d_2)
	animateRotation(animated_sprite_2d_2)
	#fadeIn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func fadeIn(wait):
	animated_sprite_2d_2.set_frame_and_progress(randi_range(0,6), 1)
	animated_sprite_2d_2.rotation_degrees = randf_range(-8,8)
	
	if randi_range(0,1) == 1:
		z_index += 1
	
	await get_tree().create_timer(wait).timeout
	
	var tween = create_tween()
	var addition = randf_range(0, 1)
	tween.tween_property(animated_sprite_2d_2, "scale", Vector2(4,4), .25)

func fadeOut(wait):
	await get_tree().create_timer(wait).timeout
	
	var tween = create_tween()
	
	tween.tween_property(animated_sprite_2d_2, "scale", Vector2(0,0), randf_range(0.25,0.55))
	
	if z_index > 110:
		z_index -= 1
	
func animateFloat(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "offset:y", -3, 2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(object, "offset:y", 0, 2).set_ease(Tween.EASE_IN).set_delay(2)
	
	tween.set_loops()
	
func animateRotation(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", 8, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -8, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()

func bumbUpDown(val):
	animated_sprite_2d_2.set_frame_and_progress(randi_range(0,8), 1)
	animated_sprite_2d_2.rotation_degrees = randf_range(-8,8)
	await get_tree().create_timer(val).timeout
	
	var tween = create_tween()
	
	tween.tween_property(animated_sprite_2d_2, "scale", Vector2(5,5), 1).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite_2d_2, "scale", Vector2(4,4), .55).set_trans(Tween.TRANS_BACK)

	tween.set_loops()
