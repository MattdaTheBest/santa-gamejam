extends Node2D
@onready var front_faces: TileMapLayer = $ysortedOBJ/frontFaces
@onready var doors_front: TileMapLayer = $ysortedOBJ/doorsFront
@onready var player_ui: CanvasLayer = $playerUI
@onready var buildings: TileMapLayer = $ysortedOBJ/buildings
var doorCount : int = 0

const FOLLOW_SPEED = 4.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("findDoors")
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func findDoors():
	var doors : int
	for n in buildings.get_children():
		if n.is_in_group("door"):
			doors += 1
	
	doorCount = doors
	player_ui.setDoors(doorCount)		
