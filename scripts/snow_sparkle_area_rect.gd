extends Area2D

const SNOW_SHINE = preload("res://scenes/Buildings/TileMaps/tilemap assests/snow_shine.tscn")
@onready var collision_shape : CollisionShape2D = $CollisionShape2D  # Reference to the CollisionShape2D node

var timer : Timer  # Timer to control the particle spawn rate

func _ready():
	# Set up a timer to trigger particle spawn every 0.2 seconds (adjustable)
	timer = Timer.new()
	timer.wait_time = 0.4  # Time interval between particle spawns
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	
	# Corrected signal connection
	timer.connect("timeout", Callable(self, "_on_timeout"))

func _on_timeout():
	# Generate a random point within the rectangle's bounds defined by the CollisionShape2D
	var random_pos = get_random_point_in_rectangle()
	
	# Spawn the particle at the random position
	spawn_particle(random_pos)

func get_random_point_in_rectangle() -> Vector2:
	# Get the RectangleShape2D from the CollisionShape2D
	var rect_shape = collision_shape.shape as RectangleShape2D
	
	# Get the size and position of the rectangle
	var size = rect_shape.extents * 2  # extents give half the width/height
	var position = collision_shape.position - rect_shape.extents  # Top-left corner of the rectangle

	# Generate a random point inside the rectangle
	var random_x = randf_range(position.x, position.x + size.x)
	var random_y = randf_range(position.y, position.y + size.y)
	
	return Vector2(random_x, random_y)

func spawn_particle(position: Vector2):
	# Instantiate a new particle system (Particle2D)
	var particle_instance = SNOW_SHINE.instantiate()
	particle_instance.position = position
	add_child(particle_instance)  # Add particle to the scene tree
