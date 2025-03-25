extends Control

@onready var time: Label = $time2/timelabel

var sec_rot : int = -90

@onready var minute: ColorRect = $minute
@onready var second: ColorRect = $second

var time_seconds : int = 0
var time_minutes : int = 0

@onready var top: Sprite2D = $top
@onready var base: Sprite2D = $base
@onready var timer: Timer = $Timer

var secondsTween 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time.text = "Seconds: "  + str(time_seconds)
	time.size = Vector2.ZERO
	
	$time2.position = Vector2(position.x - 135, position.y - $time2.size.y/2)

func _on_timer_timeout() -> void:
	time_seconds += 1
	
	if time_seconds%16 == 0:
		animate_timer()
		click()
		minute.rotation_degrees += 16
		time_minutes += 1

func stop():
	timer.paused = true
	secondsTween.kill()

func reset():
	sec_rot = -90
	time_seconds = 0
	time_minutes = 0

func start():
	animate_timer()
	timer.start(1)
	

func animate_timer():
	
	secondsTween = create_tween()
	
	secondsTween.tween_property(second, "rotation_degrees", second.rotation_degrees + 360, 16)

func bumpBlock(block):
	var tween = create_tween()
	
	tween.tween_property(block, "scale", Vector2(1.5,1.5), .35).set_trans(Tween.TRANS_BACK)
	tween.tween_property(block, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK)
	
func click():
	var tween = create_tween()
	
	tween.parallel().tween_property(top, "scale", Vector2(6.5,3), .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(top, "position:y", -47, .35).set_trans(Tween.TRANS_BACK)
	
	tween.parallel().tween_property(top, "scale", Vector2(5,5), .25).set_trans(Tween.TRANS_BACK).set_delay(.35)
	tween.parallel().tween_property(top, "position:y", -50, .35).set_trans(Tween.TRANS_BACK).set_delay(.35)
