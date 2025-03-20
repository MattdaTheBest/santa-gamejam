extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $BrickChimney2/SnowTop/GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chance = randi_range(1,3)
	if chance == 2 or chance == 3:
		gpu_particles_2d.emitting = true
	else:
		gpu_particles_2d.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
