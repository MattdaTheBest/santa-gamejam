extends AnimatedSprite2D

@onready var area_2d: Area2D = $Area2D
@onready var cash_spawner: Node2D = $cashSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("present"):
		remove_from_group("door")
		get_node("/root/world").findDoors()
		body.call_deferred("free")
		area_2d.set_deferred("monitoring", false)
		cash_spawner.call_deferred("spawnCash", 10,20)
		set_frame_and_progress(2,1)
