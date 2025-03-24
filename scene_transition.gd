extends CanvasLayer

@onready var h_box_container: HBoxContainer = $sceneTransition/HBoxContainer
const SHOP_SCENE = preload("res://shop_scene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fadeOUT()
	pass # Replace with function body.

func fadeIN():	
	for nodes in h_box_container.get_children():
		for node in nodes.get_children():
			node.fadeIn()
			
func fadeOUT():	
	for nodes in h_box_container.get_children():
		for node in nodes.get_children():
			node.fadeOut()

func changeSceneUI(newScene):
	fadeIN()
	await get_tree().create_timer(1.5).timeout
	PlayerUi.reset()
	PlayerUi.appearUI()
	await get_tree().create_timer(1.5).timeout
	#get_tree().call_deferred("change_scene_to_packed", newScene)
	get_tree().change_scene_to_packed(newScene)

func changeSceneNOUI(newScene):
	fadeIN()
	await get_tree().create_timer(1.5).timeout
	PlayerUi.reset()
	PlayerUi.hideUI()
	await get_tree().create_timer(1.5).timeout
	#get_tree().call_deferred("change_scene_to_packed", newScene)
	get_tree().change_scene_to_packed(newScene)
