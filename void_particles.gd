extends GPUParticles2D

var pActual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = pActual.offset
	rotation = pActual.rotation

func setPresentActual(p):
	pActual = p
