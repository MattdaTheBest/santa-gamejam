extends PathFollow2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setTexture(sprite):
	sprite_2d.call_deferred("set_texture", sprite)

func go():
	sprite_2d.rotation_degrees = randf_range(0, 360)
	var tween = create_tween()
	
	tween.parallel().tween_property(self, "progress_ratio", 1, .75)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(5.25,5.25), .375).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(0,0), .375).set_delay(.375).set_ease(Tween.EASE_IN)
	await tween.finished
	gpu_particles_2d.emitting = true
	get_parent().get_parent().get_parent().updatePointBufferAmount(1)
	#get_parent().get_parent().get_parent().buffer_timer.start(.125)
	
func goJaffa():
	sprite_2d.rotation_degrees = randf_range(0, 360)
	var tween = create_tween()
	
	tween.parallel().tween_property(self, "progress_ratio", 1, 1)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(5.25,5.25), .5).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(0,0), .5).set_delay(.5).set_ease(Tween.EASE_IN)
	await tween.finished
	gpu_particles_2d.emitting = true
	PlayerVariables.playerJaffas += 1

		
