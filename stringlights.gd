extends Node2D

@export var a : Node2D
@export var b : Node2D
@export var c : Node2D
@onready var lights: Line2D = $"."

const LIGHT = preload("res://light.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("draw_lights", a.position, b.position, c.position)
	#draw_lights(a.global_position, b.global_position, c.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#global_position = get_local_mouse_position()
	pass

func draw_lights(p0: Vector2, p1: Vector2, p2: Vector2):
	position = Vector2.ZERO

	lights.clear_points()
	var t = 0.0
	lights.add_point(p0)
	while t < 1:
		var q0 = p0.lerp(p1, t)
		var q1 = p1.lerp(p2, t)
		var r = q0.lerp(q1, t)
		t += .01
		lights.add_point(r)
	lights.add_point(p2)
	
	var index = 0
	var color_index = 0	
	var lastLightPos = p0
	for p in lights.points:
		#if index % 10 == 0 and index != 0:
		if (lastLightPos.distance_to(lights.get_point_position(index)) >= 7):
			lastLightPos = lights.get_point_position(index)
			var light = LIGHT.instantiate()
			get_parent().add_child(light)
			light.position = lights.get_point_position(index)
			light.rotation_degrees = randf_range(-5,5)
			light.set_color(color_index % light.color_options.size())
			color_index += 1
			#bulb.modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		index += 1
	
