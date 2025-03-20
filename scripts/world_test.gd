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
	startTime = Time.get_time_dict_from_system()
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
		
		endTime = Time.get_time_dict_from_system()

		var minute = int(Time.get_time_dict_from_system().minute) - int(startTime.minute)
		var second = int(Time.get_time_dict_from_system().second) - int(startTime.second)

		if second < 10:
			second = "0" + str(second)
		
		if minute < 10:
			minute = "0" + str(minute)
		print((str(minute) + ":" + str(second)))
		PlayerVariables.playerCurrLevelTime = (str(minute) + ":" + str(second))
		PlayerUi.openEndScreen()
		

func findDoors():
	var doors : int
	for n in buildings.get_children():
		if n.is_in_group("door"):
			doors += 1		
			
	doorCount = doors
	PlayerUi.setDoors(doorCount)
	
