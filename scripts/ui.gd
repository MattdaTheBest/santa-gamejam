extends CanvasLayer

@onready var cash: Label = $Control/VBoxContainer/cash
@onready var doors: Label = $Control/VBoxContainer/doors
@onready var jaffas: Label = $Control/VBoxContainer/jaffas
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var control: Control = $Control
@onready var player: CharacterBody2D = $"../ysortedOBJ/player"
@onready var panel_container: PanelContainer = $Control/PanelContainer
@onready var label: Label = $Control/PanelContainer/Label



var uiPresentsList = []

const UI_PRESENT = preload("res://scenes/ui_present.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animateLabel()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateZ()
	updateLabel(delta)

func updateZ():
	for p in player.presentList:
		h_box_container.get_child(player.presentList.find(p)).z_index = player.maxTrailSize - player.presentList.find(p)

func animateLabel():
	var tween = create_tween()
	
	tween.tween_property(panel_container, "rotation_degrees", randf_range(-2,0),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.tween_property(panel_container, "rotation_degrees", randf_range(0,2),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.set_loops()

func updateLabel(delta):
	if uiPresentsList.size() > 0:
		var tween = create_tween()
		tween.tween_property(panel_container, "scale:x", 1, .25)
		panel_container.global_position = panel_container.global_position.lerp(h_box_container.get_child(0).present.global_position - Vector2(panel_container.size.x/2,0), 5 * delta)
		label.text = " " + str(h_box_container.get_child(0).presentType) + " Present "
	else:
		var tween = create_tween()
		tween.tween_property(panel_container, "scale:x", 0, .25)

func updateMoney(value):
	cash.text = ("Cash: " + str(value))
	
func setDoors(value):
	doors.text = ("Remaining Doors: " + str(value))
	
func updateJaffas(value):
	jaffas.text = ("Jaffas: " + str(value))	
	
func addPresent(color, index, presentReference, type):
	var Present = UI_PRESENT.instantiate()
	Present.presentActual = presentReference
	uiPresentsList.append(Present)
	Present.call_deferred("setColor", color)
	h_box_container.add_child(Present)
	sortPresents()
	Present.appear(type)

func removePresent(presentReference):
	var present
	for p in h_box_container.get_children():
		if not p.beingRemoved:
			p.beingRemoved = true
			uiPresentsList.remove_at(uiPresentsList.find(p))
			present = p
			break
			
	present.call_deferred("dissapear")
	sortPresents()

func sortPresents():
	var index = 0 
	for p in player.presentList:
		for uiP in uiPresentsList:
			if p == uiP.presentActual:
				uiP.index = index
				h_box_container.move_child(uiP,index)
				break
		
		index += 1
	
