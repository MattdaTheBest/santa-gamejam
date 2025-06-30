extends Node2D

@onready var bulb: Sprite2D = $bulb
var color_options : Array
@onready var point_light_2d: PointLight2D = $PointLight2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	color_options.append(Color.BLUE)
	color_options.append(Color.GREEN)
	color_options.append(Color.RED)
	color_options.append(Color.YELLOW)
	color_options.append(Color.WHITE)

func set_color(index):
	bulb.modulate = color_options[index]
	point_light_2d.color = color_options[index]
