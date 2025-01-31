extends Node2D

const UI_PRESENT = preload("res://scenes/ui_present.tscn")
@onready var player_ui: CanvasLayer = $playerUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		addPresent()
	elif Input.is_action_just_pressed("q"):
		removePresent()
		

func addPresent():
	var present = UI_PRESENT.instantiate()
	present.z_index = 100 - player_ui.h_box_container.get_child_count()
	player_ui.h_box_container.add_child(present)
	
func removePresent():
	var present = player_ui.h_box_container.get_child(0)
	present.dissapear()
	
	
	
	
