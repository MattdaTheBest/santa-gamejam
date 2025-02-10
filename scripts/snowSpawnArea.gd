extends Area2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
const SNOW_SHINE = preload("res://scenes/Buildings/TileMaps/tilemap assests/snow_shine.tscn")
var timer : Timer  # Timer to control the particle spawn rate

func _ready():
	# Set up a timer to trigger particle spawn every 0.2 seconds (adjustable)
	timer = Timer.new()
	timer.wait_time = 0.125  # Time interval between particle spawns
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	
	# Corrected signal connection
	timer.connect("timeout", Callable(self, "_on_timeout"))

func _on_timeout():
	# Generate a random point within the Polygon2D's shape
	var random_pos = get_random_point_in_polygon()
	
	# Spawn the particle at the random position
	spawn_particle(random_pos)

func get_random_point_in_polygon() -> Vector2:
	# Get the Polygon2D node (assuming it's a child of this Area2D)
	  # Change this to match your scene tree structure
	var vertices = collision_polygon_2d.polygon  # Get the vertices of the polygon
	
	if vertices.size() < 3:
		return Vector2.ZERO  # Not enough points to form a polygon
	
	# Triangulate the polygon and get a random triangle
	var random_triangle = get_random_triangle(vertices)
	
	# Get the random point inside the triangle
	var random_point = get_random_point_in_triangle(random_triangle)
	
	return random_point

func get_random_triangle(vertices: Array) -> Array:
	# Select a random triangle from the polygon (assuming convex)
	var i = randi() % (vertices.size() - 2) + 1
	return [vertices[0], vertices[i], vertices[i + 1]]  # Choose a triangle

func get_random_point_in_triangle(triangle: Array) -> Vector2:
	# Get the vertices of the triangle
	var p0 = triangle[0]
	var p1 = triangle[1]
	var p2 = triangle[2]
	
	# Generate random numbers (u, v) for barycentric coordinates
	var u = randf()
	var v = randf()
	
	# Ensure u + v <= 1 to stay inside the triangle
	if u + v > 1.0:
		u = 1.0 - u
		v = 1.0 - v
	
	# Compute the random point using the barycentric coordinates
	var point = p0 * (1 - u - v) + p1 * u + p2 * v
	
	return point

func spawn_particle(position: Vector2):
	# Instantiate a new particle system (Particle2D)
	var particle_instance = SNOW_SHINE.instantiate()
	particle_instance.position = position
	add_child(particle_instance)  # Add particle to the scene tree
