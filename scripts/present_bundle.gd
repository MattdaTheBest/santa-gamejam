extends Sprite2D

@onready var shadow: Sprite2D = $shadow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounce()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bounce():
	var tween = create_tween()
	
	tween.parallel().tween_property(self, "offset:y", 3, 1)
	tween.parallel().tween_property(shadow, "scale", Vector2(.75,.75), 1)
	tween.parallel().tween_property(self, "offset:y", 0, 1).set_delay(1)
	tween.parallel().tween_property(shadow, "scale", Vector2(1,1), 1).set_delay(1)
	
	tween.set_loops()
