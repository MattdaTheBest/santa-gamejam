extends CanvasLayer

@onready var cash: Label = $Control/VBoxContainer/cash
@onready var doors: Label = $Control/VBoxContainer/doors
@onready var jaffas: Label = $Control/VBoxContainer/jaffas
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var control: Control = $Control
@onready var p_name: PanelContainer = $Control/PName
@onready var present_name: Label = $Control/PName/PresentName
@onready var p_cap: PanelContainer = $Control/PCap
@onready var present_cap: Label = $Control/PCap/PresentCap
@onready var label_current_money: PanelContainer = $Control/moneyUI/LabelCurrentMoney
@onready var label_added_money: PanelContainer = $Control/moneyUI/LabelAddedMoney
@onready var piggy_bank: TextureRect = $Control/moneyUI/piggyBank

@onready var label_buffer: Label = $Control/moneyUI/LabelAddedMoney/LabelBuffer
@onready var label_current: Label = $Control/moneyUI/LabelCurrentMoney/LabelCurrent

var moneyBufferValue = 0
var currentMoney = 0
@onready var money_buffer_timer: Timer = $Control/moneyUI/LabelAddedMoney/moneyBufferTimer

var jaffasBufferValue = 0
var currentJaffas = 0
@onready var label_current_jaffas: PanelContainer = $Control/moneyUI/LabelCurrentJaffas
@onready var label_added_jaffas: PanelContainer = $Control/moneyUI/LabelAddedJaffas
@onready var label_buffer_jaffas: Label = $Control/moneyUI/LabelAddedJaffas/LabelBufferJaffas
@onready var label_current_jafs: Label = $Control/moneyUI/LabelCurrentJaffas/LabelCurrentJafs
@onready var jaffa_buffer_timer: Timer = $Control/moneyUI/LabelAddedJaffas/jaffaBufferTimer

@onready var doors_left: PanelContainer = $Control/doorUI/DoorsLeft
@onready var label_doors_left: Label = $Control/doorUI/DoorsLeft/LabelDoorsLeft
@onready var ui_door: Sprite2D = $Control/doorUI/UiDoor

@onready var timer_2: Control = $Control/timer2


var piggyBankTween : Tween

var uiPresentsList = []

const UI_PRESENT = preload("res://scenes/ui_present.tscn")

@onready var money_ui: Control = $Control/moneyUI

#@onready var scene_transition: Control = $sceneTransition

const END_SCREEN_UI = preload("res://endScreenUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("animateLabel",p_name)
	call_deferred("animateLabel",p_cap)

	animatePiggyBank()
	await get_tree().create_timer(randf_range(0,1)).timeout
	animateDoorUI()
	animateTimerUI()
	await get_tree().create_timer(.5).timeout
	
	#scene_transition.call_deferred("fadeOUT")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(PlayerVariables.playerMoney)
	#print(PlayerVariables.christmasCheetLVL)
	#print(PlayerVariables.christmasCheerXP)
	updateLabel(delta)
	
	if currentMoney < 20:
		label_current.add_theme_color_override("font_color", Color.RED)
	else:
		label_current.add_theme_color_override("font_color", Color(0.13, 0.12,0.20,1.00))
	
	#print(str(PlayerVariables.playerMoney) + ", " + str(PlayerVariables.playerJaffas) + ", " + str(PlayerVariables.christmasCheerXP) + ", " + str(PlayerVariables.christmasCheetLVL))
	
	#print(PlayerVariables.presentList)
		
	#if Input.is_action_just_pressed("spacebar"):
		#openEndScreen()	
		
	#print(LevelComplete.size())

func hideUI():
	visible = false

func appearUI():
	visible = true

func reset():
	#if PlayerVariables.playerMoney > 0:
		##if PlayerVariables.playerMoney / 100 != 0:
			##PlayerVariables.christmasCheetLVL += PlayerVariables.playerMoney / 100
		#
		##PlayerVariables.christmasCheerXP + (PlayerVariables.playerMoney % 100)
		#
		#PlayerVariables.christmasCheerXP += PlayerVariables.playerMoney
		#
		#if PlayerVariables.christmasCheerXP >= 100:
			#PlayerVariables.christmasCheetLVL += int(PlayerVariables.christmasCheerXP/100)
			#PlayerVariables.christmasCheerXP = (int(PlayerVariables.christmasCheerXP) % 100)
		#
		#PlayerVariables.playerMoney = 0
		#
		#
	#if PlayerVariables.playerCurrLevelJaffas > 0:
		#PlayerVariables.playerJaffas += PlayerVariables.playerCurrLevelJaffas
		#PlayerVariables.playerCurrLevelJaffas = 0
	
	PlayerVariables.playerJaffas += PlayerVariables.playerCurrLevelJaffas
	PlayerVariables.playerCurrLevelJaffas = 0
	timer_2.reset()
	
	moneyBufferValue = 0
	currentMoney = 0
	money_buffer_timer.stop()
	jaffa_buffer_timer.stop()
	jaffasBufferValue = 0
	currentJaffas = 0
	
	uiPresentsList.clear()
	PlayerVariables.presentList.clear()
	for child in h_box_container.get_children():
		child.call_deferred("free")
	
	call_deferred("animateLabel",p_name)
	call_deferred("animateLabel",p_cap)

	money_ui.scale = Vector2(1,1)
	money_ui.rotation_degrees = 0

	label_current.text = "       $ " + str(0)
	label_current_jafs.text = "       J " + str(0)
	
	animatePiggyBank()
	await get_tree().create_timer(randf_range(0,1)).timeout
	animateDoorUI()
	await get_tree().create_timer(.5).timeout
	
func openEndScreen():
	var popUp = END_SCREEN_UI.instantiate()
	add_child(popUp)
	popUp.openEndScreen()

func animateTimerUI():
	var tween = create_tween()
	var random_up = randf_range(-5,-1)
	var random_down = -random_up
	var random_rotation = randf_range(5,0)
	
	#tween.parallel().tween_property(doors_left,"position:y", doors_left.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(timer_2,"position:y", timer_2.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(timer_2, "rotation_degrees", random_rotation,1.5).set_ease(Tween.EASE_IN)
	#tween.parallel().tween_property(doors_left,"position:y", doors_left.position.y - random_down,1.25).set_delay(2)	
	tween.parallel().tween_property(timer_2,"position:y", timer_2.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(timer_2, "rotation_degrees", -random_rotation,1.5).set_delay(1.5).set_ease(Tween.EASE_IN)

	
	tween.set_loops()		
func animateDoorUI():
	var tween = create_tween()
	var random_up = randf_range(-5,-1)
	var random_down = -random_up
	var random_rotation = randf_range(5,0)
	
	tween.parallel().tween_property(doors_left,"position:y", doors_left.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(ui_door,"position:y", ui_door.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(ui_door, "rotation_degrees", random_rotation,1.5).set_ease(Tween.EASE_IN)	
	tween.parallel().tween_property(doors_left,"position:y", doors_left.position.y - random_down,1.25).set_delay(2)	
	tween.parallel().tween_property(ui_door,"position:y", ui_door.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(ui_door, "rotation_degrees", -random_rotation,1.5).set_delay(1.5).set_ease(Tween.EASE_IN)
	
	tween.set_loops()	

func updateMoneyDirectAmount():
	currentMoney -= 1
	label_current.text = "       $ " + str(currentMoney)

func updateJaffaBufferAmount(value):
	if jaffasBufferValue == 0:
		var tween = create_tween()
		tween.tween_property(label_added_jaffas, "scale:x", 1, .35).set_trans(Tween.TRANS_BACK)
		await  tween.finished
	
	jaffasBufferValue += value
	label_buffer_jaffas.text = "    +J " + str(jaffasBufferValue) + " "
	
	var tween = create_tween()
	tween.tween_property(label_added_jaffas, "scale", Vector2(1.125,1), .35).set_trans(Tween.TRANS_BACK)
	tween.tween_property(label_added_jaffas, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK)
	
	jaffa_buffer_timer.start(1)

func countDownJaffas():
	await get_tree().create_timer(0.0625 - jaffasBufferValue/10).timeout
	if jaffasBufferValue > 0:
		jaffasBufferValue -= 1
		currentJaffas += 1
		label_buffer_jaffas.text = "    +J " + str(jaffasBufferValue) + " "
		label_current_jafs.text = "       J " + str(currentJaffas)
	
	if jaffasBufferValue > 0 and jaffa_buffer_timer.is_stopped():
		countDownJaffas()
	elif jaffasBufferValue == 0:
		var tween = create_tween()
		
		if piggyBankTween:
			piggyBankTween.kill()
			
		piggyBankTween = create_tween()	

		piggyBankTween.parallel().tween_property(piggy_bank, "scale", Vector2(6,6), .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(label_current_jaffas, "scale", Vector2(1.125,1), .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(label_current_jaffas, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK).set_delay(.35)
		piggyBankTween.parallel().tween_property(piggy_bank, "scale", Vector2(5,5), .2).set_trans(Tween.TRANS_BACK).set_delay(.25)
		collapseJaffaBufferLabel()
	
func updateMoneyBufferAmount(value):
	if (moneyBufferValue + value) < 0:
		label_added_money.modulate = Color("aa1b47")
	else:
		label_added_money.modulate = Color("1ebc73")
	
	if moneyBufferValue == 0:
		var tween = create_tween()
		tween.tween_property(label_added_money, "scale:x", 1, .35).set_trans(Tween.TRANS_BACK)
		await  tween.finished
	
	moneyBufferValue += value
	label_buffer.text = "    +$ " + str(moneyBufferValue) + " "
	
	var tween = create_tween()
	tween.tween_property(label_added_money, "scale", Vector2(1.125,1), .35).set_trans(Tween.TRANS_BACK)
	tween.tween_property(label_added_money, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK)
	
	money_buffer_timer.start(1)
	
func countDownMoney():
	await get_tree().create_timer(0.0625 - abs(moneyBufferValue/10)).timeout
	if moneyBufferValue > 0:
		label_added_money.modulate = Color("1ebc73")
		moneyBufferValue -= 1
		currentMoney += 1
		label_buffer.text = "    +$ " + str(moneyBufferValue) + " "
		label_current.text = "       $ " + str(currentMoney)
		
	elif moneyBufferValue < 0:
		label_added_money.modulate = Color("aa1b47")
		moneyBufferValue += 1
		currentMoney -= 1
		label_buffer.text = "    +$ " + str(moneyBufferValue) + " "
		label_current.text = "       $ " + str(currentMoney)
		
	
	if moneyBufferValue != 0 and money_buffer_timer.is_stopped():
		countDownMoney()
	elif moneyBufferValue == 0:
		var tween = create_tween()
		
		if piggyBankTween:
			piggyBankTween.kill()
			
		piggyBankTween = create_tween()	

		piggyBankTween.parallel().tween_property(piggy_bank, "scale", Vector2(6,6), .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(label_current_money, "scale", Vector2(1.125,1), .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(label_current_money, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK).set_delay(.35)
		piggyBankTween.parallel().tween_property(piggy_bank, "scale", Vector2(5,5), .2).set_trans(Tween.TRANS_BACK).set_delay(.25)
		collapseMoneyBufferLabel()
	
func collapseMoneyBufferLabel():
	var tween = create_tween()
	tween.tween_property(label_added_money, "scale:x", 0, .25).set_trans(Tween.TRANS_BACK).set_delay(.25)

func collapseJaffaBufferLabel():
	var tween = create_tween()
	tween.tween_property(label_added_jaffas, "scale:x", 0, .25).set_trans(Tween.TRANS_BACK).set_delay(.25)
	
func collapseAllLabels():
	var tween = create_tween()
	tween.parallel().tween_property(label_current_money, "scale:x", 0, .25).set_trans(Tween.TRANS_BACK).set_delay(.25)
	tween.parallel().tween_property(label_current_jaffas, "scale:x", 0, .25).set_trans(Tween.TRANS_BACK).set_delay(.25)
		
func animatePiggyBank():
	var tween = create_tween()
	var random_up = randf_range(-5,-1)
	var random_down = -random_up
	var random_rotation = randf_range(5,0)
	
	tween.parallel().tween_property(label_current_money,"position:y", label_current_money.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label_added_money,"position:y", label_added_money.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label_current_jaffas,"position:y", label_current_jaffas.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label_added_jaffas,"position:y", label_added_jaffas.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(piggy_bank,"position:y", piggy_bank.position.y - random_up,2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(piggy_bank, "rotation_degrees", random_rotation,1.5)

	
	tween.parallel().tween_property(label_current_money,"position:y", label_current_money.position.y - random_down,1.25).set_delay(2)	
	tween.parallel().tween_property(label_added_money,"position:y", label_added_money.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(label_current_jaffas,"position:y", label_current_jaffas.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(label_added_jaffas,"position:y", label_added_jaffas.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(piggy_bank,"position:y", piggy_bank.position.y - random_down,1.25).set_delay(2)
	tween.parallel().tween_property(piggy_bank, "rotation_degrees", -random_rotation,1.5).set_delay(1.5)
	
	tween.set_loops()
	
func updateZ():
	for p in PlayerVariables.presentList:
		if p != null:
			h_box_container.get_child(PlayerVariables.presentList.find(p)).z_index = PlayerVariables.maxTrailSize - PlayerVariables.presentList.find(p)

func animateLabel(object):
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", randf_range(-2,0),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.tween_property(object, "rotation_degrees", randf_range(0,2),1.5).set_ease(Tween.EASE_OUT).set_delay(randf_range(0,.75))
	tween.set_loops()

func animateLabelMore(object):
	await get_tree().create_timer(randf_range(0,.75)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "position:y", object.position.y - 5,1.5).set_trans(Tween.TRANS_CUBIC).set_delay(.01 + randf_range(0,0.05))
	tween.parallel().tween_property(object, "rotation_degrees", randf_range(-0.75,-0.5),1.5).set_trans(Tween.TRANS_CUBIC).set_delay(.01 + randf_range(0,0.05))
	
	tween.parallel().tween_property(object, "position:y", object.position.y + 5,1.5).set_ease(Tween.EASE_OUT).set_delay(1.51 + randf_range(0,0.05))
	tween.parallel().tween_property(object, "rotation_degrees", randf_range(0.5,0.75),1.5).set_trans(Tween.TRANS_CUBIC).set_delay(1.51 + randf_range(0,0.05))
	
	tween.set_loops()

func updateLabel(delta):
	if uiPresentsList.size() > 0:
		var tween = create_tween()
		tween.parallel().tween_property(p_name, "scale:x", 1, .25)
		tween.parallel().tween_property(p_cap, "scale:x", 1, .25)
		p_name.global_position = p_name.global_position.lerp(h_box_container.get_child(0).present.global_position - Vector2(p_name.size.x/2,0), 5 * delta)
		p_cap.global_position = p_cap.global_position.lerp(h_box_container.get_child(0).present.global_position - Vector2(p_cap.size.x/2,-25), 5 * delta)
		present_name.text = " " + str(h_box_container.get_child(0).presentType) + " "
		present_cap.text = " " + str(uiPresentsList.size()) + " / " + str(PlayerVariables.maxTrailSize) + " "
	else:
		var tween = create_tween()
		tween.parallel().tween_property(p_name, "scale:x", 0, .25)
		tween.parallel().tween_property(p_cap, "scale:x", 0, .25)
	
func setDoors(value):
	label_doors_left.text = "           Doors Left: " + str(value) + " "
	
	var tween = create_tween()
	tween.parallel().tween_property(doors_left, "scale", Vector2(1.125,1), .25).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(ui_door, "scale", Vector2(6,6), .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(doors_left, "scale", Vector2(1,1), .25).set_trans(Tween.TRANS_BACK).set_delay(.25)
	tween.parallel().tween_property(ui_door, "scale", Vector2(5,5), .2).set_trans(Tween.TRANS_BACK).set_delay(.25)
		
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
	for p in PlayerVariables.presentList:
		for uiP in uiPresentsList:
			if p == uiP.presentActual:
				uiP.index = index
				h_box_container.move_child(uiP,index)
				break
		
		index += 1
	
	updateZ()
	
func _on_money_buffer_timer_timeout() -> void:
	countDownMoney()

func _on_jaffa_buffer_timer_timeout() -> void:
	countDownJaffas()
