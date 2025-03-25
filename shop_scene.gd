extends CanvasLayer

@onready var background_animation: Control = $backgroundAnimation
@onready var Anni_h_box_container: HBoxContainer = $backgroundAnimation/HBoxContainer

@onready var panel: Panel = $Control/upgradePanel
@onready var h_box_container: HBoxContainer = $Control/upgradeHBoxContainer

@onready var passivepanel: Panel = $Control/passivepanel

@onready var new_panel: Panel = $Control/newPanel
@onready var new_h_box_container: HBoxContainer = $Control/newHBoxContainer

@onready var new: PanelContainer = $Control/new
@onready var upgrade: PanelContainer = $Control/upgrade
@onready var info: PanelContainer = $Control/info
@onready var info_title: PanelContainer = $Control/infoTitle
@onready var lights: Line2D = $Control/Node2D/lights
@onready var jaffa: PanelContainer = $Control/jaffa
@onready var jafalabel: Label = $Control/jaffa/jafalabel
@onready var sprite_2d: Sprite2D = $Control/Sprite2D

var infoTween
const LIGHT = preload("res://light.tscn")
#@onready var shop: PanelContainer = $Control/shop

var presentsDisplayed = []
const WORLD_TEST = preload("res://scenes/world_test.tscn")

var upgradeAmount : int = 4
var newAmount : int = 1

const SHOP_SCENE_PRESENT = preload("res://shop_scene_present.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeIN()
	await get_tree().create_timer(1).timeout
	SceneTransition.fadeOUT()
	spawnUpgrades()
	spawnNew()
	PlayerUi.hideUI()

	scalePanel()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control/mainMenu.global_position.y = $Control/Panel.global_position.y + $Control/Panel.size.y - $Control/mainMenu.size.y/2
	$Control/ToShop.global_position.y = $Control/Panel.global_position.y + $Control/Panel.size.y - $Control/ToShop.size.y/2
	$Control/exit.global_position.y = $Control/Panel.global_position.y + $Control/Panel.size.y - $Control/exit.size.y/2

	info.global_position.x = $Control/Panel.global_position.x + $Control/Panel.size.x + 25
	info_title.global_position.x = info.global_position.x + info.size.x/2 - info_title.size.x/2

	passivepanel.global_position.x = $Control/Panel.global_position.x - passivepanel.size.x - 25
	$Control/passive.global_position = Vector2(passivepanel.global_position.x - ($Control/passive.size.x/2) + passivepanel.size.x/2 ,passivepanel.global_position.y - $Control/passive.size.y/2)
	
	jafalabel.text = "   Jaffas: " + str(PlayerVariables.playerJaffas) + " "
	
	$Control/info.visible = !($Control/info.scale.y <= 0.01)
	$Control/infoTitle.visible = !($Control/infoTitle.scale.y <= 0.01)
	
func appearInfo(name, info):
	if infoTween:
		infoTween.kill()
	
	$Control/infoTitle.size = Vector2(0,0)
	$Control/info.size = Vector2(0,0)	
	$Control/infoTitle/infoTitleLabel.text = " " + name + " "
	$Control/info/infolabel.text = "                  " + info
	$Control/info.size.x += 10
	
	infoTween = create_tween()
	
	infoTween.tween_property($Control/infoTitle, "scale", Vector2(1,1), .35).set_trans(Tween.TRANS_BACK)
	infoTween.tween_property($Control/info, "scale", Vector2(1,1), .35).set_trans(Tween.TRANS_BACK)

func disappearInfo():
	if infoTween:
		infoTween.kill()
		

	infoTween = create_tween()
	
	infoTween.tween_property($Control/infoTitle, "scale", Vector2(1,0), .15)
	infoTween.tween_property($Control/info, "scale", Vector2(1,0), .15)

func scalePanel():		
	
	panel.size.x = (72 * upgradeAmount) + (25 * (upgradeAmount + 1))
	new_panel.size.x = (72 * newAmount) + (25 * (newAmount + 1))

	new_panel.global_position.x = panel.global_position.x + panel.size.x + 25
	var length = (new_panel.global_position.x + new_panel.size.x) - panel.global_position.x
	
	panel.global_position.x -= length/2
	new_panel.global_position.x = panel.global_position.x + 25 + panel.size.x
	
	new_h_box_container.global_position.x = new_panel.global_position.x + (new_panel.size.x/2)
	h_box_container.global_position.x = panel.global_position.x + (panel.size.x/2)

	upgrade.global_position.x = panel.global_position.x + panel.size.x/2 - upgrade.size.x/2
	new.global_position.x = new_panel.global_position.x + new_panel.size.x/2 - new.size.x/2
	
	var length2 = 412
	
	$Control/shopsign/S.global_position.x -= 156
	$Control/shopsign/H.global_position.x = $Control/shopsign/S.global_position.x + 104
	$Control/shopsign/O.global_position.x = $Control/shopsign/H.global_position.x + 104
	$Control/shopsign/P.global_position.x = $Control/shopsign/O.global_position.x + 104

	$Control/Panel.size.x = length + 50
	$Control/Panel.global_position.x -= (length + 50)/2
	
	$Control/exit.global_position.x -=  86 + 25
	$Control/ToShop.global_position.x += 86 + 25
	#$Control/jaffa.global_position
	
	passivepanel.position.y = -165 -passivepanel.size.y/2 + (275/2)
	jaffa.position = Vector2($Control/Panel.position.x + 555, -165 - jaffa.size.y/2)
	sprite_2d.position = Vector2(jaffa.position.x - 12.5, jaffa.position.y + 12.5)
	
	new_panel.pivot_offset = new_panel.size/2
	panel.pivot_offset = panel.size/2
	upgrade.pivot_offset = upgrade.size/2
	new.pivot_offset = new.size/2
	$Control/Panel.pivot_offset = $Control/Panel.size/2
	$Control/info.pivot_offset = $Control/info.size/2
	$Control/infoTitle.pivot_offset = $Control/infoTitle.size/2
	$Control/passivepanel.pivot_offset = $Control/passivepanel.size/2
	$Control/passive.pivot_offset = $Control/passive.size/2
	$Control/jaffa.pivot_offset = $Control/jaffa.size/2
	
	animateFloat($Control/upgradePanel, 4)
	animateFloat($Control/upgrade, 4)
	animateFloat($Control/new, 4)
	animateFloat($Control/newPanel, 4)
	animateFloat($Control/info, 4)
	animateFloat($Control/passivepanel, 4)
	animateFloat($Control/infoTitle, 4)				
	animateFloat($Control/shopsign/S, 8)
	animateFloat($Control/shopsign/H, 8)
	animateFloat($Control/shopsign/O, 8)
	animateFloat($Control/shopsign/P, 8)
	animateFloat(sprite_2d, 4)
	animateFloat(jaffa, 4)
	
	animateRotation($Control/passive,1)
	animateRotation($Control/passivepanel,1)
	animateRotation($Control/newPanel,1)
	animateRotation($Control/info,1)
	animateRotation($Control/upgradePanel,1)
	animateRotation($Control/infoTitle,1)	
	animateRotation($Control/shopsign/S,4)
	animateRotation($Control/shopsign/H,4)
	animateRotation($Control/shopsign/O,4)
	animateRotation($Control/shopsign/P,4)
	animateRotation(upgrade,4)
	animateRotation(new,4)
	animateRotation(sprite_2d, 4)
	animateRotation(jaffa, 4)
	
	#print(PlayerVariables.playerCurrLevelJaffas)
	#print(PlayerVariables.playerJaffas)
	
	#animateFloat(upgrade, 2)
	#animateFloat(new, 2)
	
	appearShop()
	
func appearShop():
	await get_tree().create_timer(1).timeout
	
	var tween = create_tween()
	
	#tween.tween_property($Control/Panel, "position:y", -165, .35)
	#tween.tween_property($Control/Panel, "size:y", 350, .35)
	
	tween.parallel().tween_property($Control/Panel, "size:y", 275, .75).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property($Control/Panel, "position:y", -165, .75).set_trans(Tween.TRANS_BACK)
	
	tween.set_parallel().tween_property($Control/shopsign/S, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property($Control/shopsign/H, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK).set_delay(.25)
	tween.set_parallel().tween_property($Control/shopsign/O, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK).set_delay(.45)
	tween.set_parallel().tween_property($Control/shopsign/P, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK).set_delay(.65)
	tween.set_parallel().tween_property(sprite_2d, "scale", Vector2(5,5), .55).set_trans(Tween.TRANS_BACK).set_delay(.85)
	tween.set_parallel().tween_property($Control/jaffa, "scale:x", 1, .55).set_trans(Tween.TRANS_BACK).set_delay(1.05)
	
	
	tween.set_parallel().tween_property(panel, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property($Control/passivepanel, "scale:y", 1, .75).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property(new_panel, "scale:y", 1, .55).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property(upgrade, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property(new, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK)
	tween.set_parallel().tween_property($Control/passive, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK)
	
	tween.set_parallel().tween_property(h_box_container, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK).set_delay(.5)
	tween.set_parallel().tween_property(new_h_box_container, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK).set_delay(.5)
	
	
	
	
	
	
	tween.tween_property($Control/mainMenu, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(.75)
	tween.parallel().tween_property($Control/ToShop, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(1.25)
	tween.parallel().tween_property($Control/exit, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(1.25)
	
	draw_line(Vector2(-576, -350),Vector2(0, -100),Vector2(576, -350))

func _on_button_pressed() -> void:
	SceneTransition.changeSceneUI(WORLD_TEST)

func spawnUpgrades():
	for p in upgradeAmount:
		var present = SHOP_SCENE_PRESENT.instantiate()
		h_box_container.add_child(present)
		present.chooseType("upgrade")
		
func spawnNew():
	for p in newAmount:
		var present = SHOP_SCENE_PRESENT.instantiate()
		new_h_box_container.add_child(present)
		present.chooseType("new")

func fadeIN():
	for nodes in Anni_h_box_container.get_children():
		for node in nodes.get_children():
			var index_delay = randf_range(0, 1)
			node.bumbUpDown(index_delay)
			
func animateFloat(object, amount):
	await get_tree().create_timer(randf_range(0,1)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "position:y", object.position.y - amount, 2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(object, "position:y", object.position.y + amount, 2).set_ease(Tween.EASE_IN).set_delay(2)
	
	tween.set_loops()
	
func animateRotation(object, amount):
	await get_tree().create_timer(randf_range(0,1)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", amount, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -amount, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()			

func _on_main_menu_button_pressed() -> void:
	get_tree().quit()

func _on_to_shop_button_pressed() -> void:
	SceneTransition.call_deferred("changeSceneUI", WORLD_TEST)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func draw_line(p0: Vector2, p1: Vector2, p2: Vector2):
	lights.clear_points()
	var t = 0.0
	while t < 1:
		var q0 = p0.lerp(p1, t)
		var q1 = p1.lerp(p2, t)
		var r = q0.lerp(q1, t)
		t += .01
		lights.add_point(r)
	
	var index = 0	
	for p in lights.points:
		if index % 10 == 0 and index != 0:
			var light = LIGHT.instantiate()
			$Control/Node2D.add_child(light)
			light.position = lights.get_point_position(index)
			light.rotation_degrees = randf_range(-5,5)
			light.bulb.modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		index += 1
