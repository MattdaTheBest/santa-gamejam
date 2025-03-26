extends Control

@onready var time: Label = $seconds/timelabel
@onready var timelabel_2: Label = $minutes/timelabel2
@onready var minutes: PanelContainer = $minutes


var sec_rot : int = -90

@onready var minute: ColorRect = $minute
@onready var second: ColorRect = $second

var time_seconds : int = 0
var time_minutes : int = 0

var time_secondsFORANI : int = 0

@onready var top: Sprite2D = $top
@onready var base: Sprite2D = $base
@onready var timer: Timer = $Timer

var secondsTween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animate_timer()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time.text = "  S : "  + str(time_seconds)
	timelabel_2.text = "  M : "  + str(time_minutes)
	time.size = Vector2.ZERO
	 
	$seconds.position = Vector2(position.x - 110, position.y - $seconds.size.y)
	$minutes.position = Vector2(position.x - 110 + $seconds.size.x - $minutes.size.x, position.y - $minutes.size.y + $minutes.size.y)

func _on_timer_timeout() -> void:
	time_seconds += 1
	time_secondsFORANI += 1
	
	if time_secondsFORANI%16 == 0:
		animate_timer()
		click()
		minute.rotation_degrees += 16
		
	if time_seconds == 60:
		minuteChange()
		time_seconds = 0
		time_minutes += 1

func minuteChange():
	var tween = create_tween()
	tween.tween_property(minutes, "scale", Vector2(1.125,1), .35).set_trans(Tween.TRANS_BACK)
	tween.tween_property(minutes, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK)

func stop():
	timer.stop()
	timer.autostart = false
	secondsTween.kill()

func reset():
	sec_rot = -90
	
	$second.rotation_degrees = -90
	$minute.rotation_degrees = -90
	
	time_secondsFORANI = 0
	time_seconds = 0
	time_minutes = 0

func start():
	animate_timer()
	timer.start(1)
	timer.autostart = true
	
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
