extends Node2D

@onready var fade_area: Area2D = $fadeArea
@onready var front: TileMapLayer = $Front
@onready var front_door: TileMapLayer = $FrontDoor
@onready var back: TileMapLayer = $Back
@onready var back_door: TileMapLayer = $BackDoor
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
	if not above and player.global_position.y < global_position.y:
		above = true
		fadeOut()
	elif above:
		above = false
		fadeIn()

func getPlayer():
	player = get_tree().get_nodes_in_group("player")[0]

func _on_fade_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		fadeOut()


func _on_fade_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		fadeIn()
		
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
