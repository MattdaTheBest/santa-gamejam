extends Control
@onready var level_end_screen_con: PanelContainer = $"Level End Screen/LevelEndScreenCon"
@onready var levelcompletetext: Control = $"Level End Screen/levelcompletetext"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animateRotation(levelcompletetext)
	animateFloat(levelcompletetext)
	animateBackDrop(level_end_screen_con)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shift"):
		openEndScreen()

func close():
	pass
	
func openEndScreen(): #size x=640 y=12 pos x=-300 y=63
	$Confettie.emitting = true
	$Confettie2.emitting = true
	$Confettie3.emitting = true

	var tween = create_tween()
	
	tween.parallel().tween_property(level_end_screen_con, "size:y", 170, .75).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(level_end_screen_con, "position:y", -550, .75).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(levelcompletetext, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(1)
	
	await tween.finished
	$EndScreenValues.optionsAppear()
	$EndScreenValues.Appear()
	
func expandEndScreen():
	var tween = create_tween()
	
	tween.parallel().tween_property(level_end_screen_con, "size:y", level_end_screen_con.size.y + 60, .75).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(level_end_screen_con, "position:y", -550, .75).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(levelcompletetext, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(1)
	
	await tween.finished
	#$CanvasLayer.Appear()
	
func animateRotation(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", 1, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -1, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()
	
func animateFloat(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "position:y", object.position.y - 3, 2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(object, "position:y",object.position.y + 3, 2).set_ease(Tween.EASE_IN).set_delay(2)
	
	tween.set_loops()
	
func animateBackDrop(object):
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", 1, 2).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -1, 2).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1).set_ease(Tween.EASE_IN)
	
	tween.set_loops()
