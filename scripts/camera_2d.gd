extends Camera2D
@onready var player: CharacterBody2D = $"../ysortedOBJ/player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.lerp(player.global_position, 5 * delta)
	
	
