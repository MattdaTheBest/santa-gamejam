extends Node2D

@export var left_flagON : bool = false
@export var right_flagON : bool = false
@export var reefON : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$reef.visible = reefON
	$rightflag.visible = right_flagON
	$leftflag.visible = left_flagON
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
