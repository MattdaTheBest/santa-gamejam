extends Node2D
@onready var buildings: TileMapLayer = $ysortedOBJ/buildings
@onready var presents: Node2D = $ysortedOBJ/presents
var doorCount : int = 0

var doorsGone : bool = false

const FOLLOW_SPEED = 4.0
const PRESENT = preload("res://scenes/present.tscn")

var startTime : Dictionary
var endTime : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("findDoors")	
	SceneTransition.fadeOUT()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spacebar"):
		var p = PRESENT.instantiate()
		p.global_position = $Marker2D.global_position
		presents.add_child(p)

	if doorCount == 0 and not doorsGone:
		doorsGone = true
		
		PlayerUi.timer_2.stop()
		PlayerVariables.playerCurrLevelTime = (str(PlayerUi.timer_2.time_minutes) + ":" + str(PlayerUi.timer_2.time_seconds))
		PlayerUi.openEndScreen()
		

func findDoors():
	var doors : int
	for n in buildings.get_children():
		if n.is_in_group("door"):
			doors += 1		
			
	doorCount = doors
	PlayerUi.setDoors(doorCount)
	PlayerUi.timer_2.start()
	
