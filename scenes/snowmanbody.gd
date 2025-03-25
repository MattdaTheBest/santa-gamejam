extends CharacterBody2D

var slowSpeed = 60
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var bounceVariable : int = 1
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _physics_process(delta: float) -> void:
	#var collision_info = move_and_collide(velocity)

#
#
	#if get_slide_collision_count() > 0:
		#var collision_info = get_slide_collision(0)
		#var collider = collision_info.get_collider()
		#if collider.is_in_group("player"):
			#velocity = collision_info.get_normal() * (collision_info.get_collider().currentSpeed/2)
		#else:
			#velocity = velocity.bounce(collision_info.get_normal())/bounceVariable
	
		#print(velocity)
	
	if velocity.x < 0:
		rotation_degrees -= velocity.x/10
	elif velocity.x > 0:
		rotation_degrees += velocity.x/10
	
	velocity = velocity.move_toward(Vector2(0,0), slowSpeed * delta)
	#move_and_slide()

	gpu_particles_2d.global_position = Vector2(global_position.x, global_position.y + 3)
	move_and_slide()
	
	for c in get_slide_collision_count():
		var collision_info = get_slide_collision(c)
		var collider = collision_info.get_collider()
		if collider.is_in_group("player"):
			velocity += collision_info.get_normal() * (collision_info.get_collider().currentSpeed)
