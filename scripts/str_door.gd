extends AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var cash_spawner: Node2D = $cashSpawner
@export var colorSpecfic = false
@onready var ribbon: AnimatedSprite2D = $Ribbon
var colorSpecficChance = 3
var color

const WRONG_PRESENT_PARTICLE = preload("res://scenes/Buildings/TileMaps/tilemap assests/wrong_present_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("setDoorSpecfic")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("present"):
		if (colorSpecfic and (body.presentactual.frame == color or body.presentactual.frame == 8)) or (not colorSpecfic):
			remove_from_group("door")
			get_tree().get_nodes_in_group("Level")[0].findDoors()	
			area_2d.set_deferred("monitoring", false)
			cash_spawner.call_deferred("spawnCash", body.presentMoneyReward, body.presentJaffaReward)
			set_frame_and_progress(2,1)
			emitParticles()
			body.call_deferred("free")
		else:
			var particle = WRONG_PRESENT_PARTICLE.instantiate()
			add_child(particle)
			#particle.position.y += 3
		
func setDoorSpecfic():	
	if randi_range(1, colorSpecficChance) == colorSpecficChance:
		colorSpecfic = true
		ribbon.visible = true
	else:
		ribbon.visible = false
		
	if colorSpecfic:
		color = randi_range(0,5)
		ribbon.set_frame_and_progress(color, 1)
			
func emitParticles():
	$closeParticles.emitting = true
	$closeParticles2.emitting = true
