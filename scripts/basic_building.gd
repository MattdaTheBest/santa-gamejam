extends Node2D


@onready var front: TileMapLayer = $Front
@onready var back: TileMapLayer = $Back
@onready var center: Marker2D = $Center
var above : bool = false
var player : CharacterBody2D

var tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("getPlayer")
	front.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not above and player.global_position.y < center.global_position.y:
		above = true
		fadeOut()
	elif above:
		above = false
		fadeIn()

func getPlayer():
	player = get_tree().get_nodes_in_group("player")[0]
		
func fadeOut():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.parallel().tween_property(front, "modulate:a", .15, .125)
	#tween.parallel().tween_property(front_door, "modulate:a", .15, .25)
	
func fadeIn():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.parallel().tween_property(front, "modulate:a", 1, 1.5)
	#tween.parallel().tween_property(front_door, "modulate:a", 1, .5)
