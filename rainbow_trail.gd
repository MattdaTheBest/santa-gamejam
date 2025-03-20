extends GPUParticles2D

var pActual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if pActual != null:
		#emitting = pActual.velocity.length() > 0
		position = pActual.position

func setPresentActual(p):
	pActual = p
