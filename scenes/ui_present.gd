extends Control

var beingRemoved : bool = false
#@onready var present: Sprite2D = $Present
#@onready var present: Sprite2D = $Sprite2D
@onready var Present: Sprite2D = $Present
@onready var present: AnimatedSprite2D = $present
@onready var marker_2d: Marker2D = $Marker2D


#@onready var present: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	appear()
	floatSelf()
	rotateSelf()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	present.global_position = present.global_position.lerp(global_position, 2 * delta)
	present.z_index = z_index

func setColor(color):
	present.set_frame_and_progress(color, 1)

func floatSelf():
	var tween = create_tween()
	
	tween.tween_property(present,"offset:y", randi_range(-2,0),2).set_ease(Tween.EASE_OUT)
	tween.tween_property(present,"offset:y", randi_range(2,0),1.25)
	tween.set_loops()

func rotateSelf():
	var tween = create_tween()
	
	tween.tween_property(present, "rotation_degrees", randf_range(-2,0),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.tween_property(present, "rotation_degrees", randf_range(0,2),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.set_loops()
	
func appear():
	present.global_position = global_position	
	set_h_size_flags(Control.SIZE_FILL)
	set_v_size_flags(Control.SIZE_SHRINK_CENTER)
	var tween = create_tween()
	
	tween.tween_property(present, "scale", Vector2(4,4), .65).set_trans(Tween.TRANS_BACK)

func dissapear():
	var tween = create_tween()
	
	tween.tween_property(present, "scale", Vector2(0,0), .65).set_trans(Tween.TRANS_BACK)
	await tween.finished
	call_deferred("free")
