extends Control

var cost : int = 0 

@onready var panel: Panel = $Panel
@onready var animated_sprite_2d: AnimatedSprite2D = $Control/AnimatedSprite2D

@onready var reward_bar: TextureProgressBar = $Panel/VBoxContainer/reward/rewardMoneyBar
@onready var reward_bar_2: TextureProgressBar = $Panel/VBoxContainer/reward/rewardJaffaBar2
@onready var reward_money_bar_buffer: TextureProgressBar = $Panel/VBoxContainer/reward/rewardMoneyBar/rewardMoneyBarBuffer
@onready var reward_jaffa_bar_buffer: TextureProgressBar = $Panel/VBoxContainer/reward/rewardJaffaBar2/rewardJaffaBarBuffer

@onready var level_label: Label = $level/levelLabel
@onready var level: PanelContainer = $level
@onready var upgrade: PanelContainer = $upgrade
@onready var progress_bar: ProgressBar = $upgrade/ProgressBar

@onready var sold_sign: PanelContainer = $SoldSign
@onready var sold_sign_label: Label = $SoldSign/SoldSignLabel

var inPanel : bool = false
var bought : bool = false
var tweenFinished : bool = false

var tween

var presentTypeFinal 
var newPresent : bool = false

signal updateComplete 

const CONFETTIE_FOR_SHOP = preload("res://confettie_for_shop.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animateFloat(animated_sprite_2d)
	animateRotation(animated_sprite_2d)
	animateRotation(upgrade)
	animateRotationLevel(level)
	animateRotation(sold_sign)
	disappearPanel()
	
	cost = randi_range(1,3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inPanel and Input.is_action_pressed("leftClick") and not bought and tweenFinished and PlayerVariables.playerJaffas >= cost:
		progress_bar.value += 1
		upgrade.scale = Vector2(1.25 + progress_bar.value/750, 1.25 + progress_bar.value/750)
		if not newPresent:
			level.scale = Vector2(1.25 + progress_bar.value/750, 1.25 + progress_bar.value/750)
	elif progress_bar.value != 0 and not bought and tweenFinished:
		progress_bar.value -= 1
		upgrade.scale = upgrade.scale.move_toward(Vector2(1.25, 1.25), 2 * delta)
		if not newPresent:
			level.scale = level.scale.move_toward(Vector2(1.25, 1.25), 2 * delta)
		#upgrade.scale = Vector2(1.25, 1.25)
		#level.scale = Vector2(1.25, 1.25)
	else:
		progress_bar.value -= 1
	pass

func bumpJaffa():
	var tween = create_tween()
	
	tween.tween_property(get_parent().get_parent().get_parent().jaffa, "scale", Vector2(1.25,1.25), .35).set_trans(Tween.TRANS_BACK)
	tween.tween_property(get_parent().get_parent().get_parent().jaffa, "scale", Vector2(1,1), .35).set_trans(Tween.TRANS_BACK)
	
	pass

func onLevelUp():
	
	
	bought = true

	var tween = create_tween()

	tween.parallel().tween_property(sold_sign, "scale", Vector2(1.25,1.25),.35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(animated_sprite_2d, "modulate:a", .35, .35).set_delay(.35)

	disappearPanel()
		
func updateBuffers():
	var temp = PresentStats.list.find(presentTypeFinal)
	var present = PresentStats.list[temp]
	var sType = presentTypeFinal.get("StatID")
	var updatedStats
	if newPresent:
		updatedStats = PresentUpgradeVariables.returnStats(sType, [0])
		print(updatedStats)
	else:
		updatedStats = PresentUpgradeVariables.returnStats(sType, present.get("Level"))	
		
	if updatedStats != null:
		var tween = create_tween()
		
		tween.parallel().tween_property(reward_money_bar_buffer, "value", updatedStats.get("reward_money")[1], .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(reward_jaffa_bar_buffer, "value", updatedStats.get("reward_jaffa")[1], .35).set_trans(Tween.TRANS_BACK)

func updateMainBar(endValueMoney, endValueJaffa):
	var tween = create_tween()
	
	tween.parallel().tween_property(reward_bar, "value", endValueMoney, .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(reward_bar_2, "value", endValueJaffa, .35).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	emit_signal("updateComplete")
		
func chooseType(type):
	var unlocked = []
	var locked = []
	
	for p in PresentStats.list:
		if p.get("Unlocked") == true:
			unlocked.append(p)
		else:
			locked.append(p)
		
	var presentListAbove = get_parent().get_parent().get_parent().presentsDisplayed
	
	for p in presentListAbove:
		if unlocked.has(p):	
			unlocked.erase(p)
		if locked.has(p):	
			locked.erase(p)
	
	var presentType 
	if type == "upgrade":
		presentType = pickNew(unlocked)
		newPresent = false
		
		$upgrade/PresentName.text = "Upgrade: " + str(cost) + " J"
	elif type == "new":
		if locked.size() == 0:
			presentType = null
		else:
			presentType = pickUpgrade(locked)
			newPresent = true
			$upgrade/PresentName.text = "  Buy: " + str(cost) + " J  "
	
	if presentType != null:	
		animated_sprite_2d.set_frame_and_progress((randi_range(presentType.get("texture_index")[0],presentType.get("texture_index")[1])), 1)
		
		get_parent().get_parent().get_parent().presentsDisplayed.append(presentType)
		
		presentTypeFinal = presentType
		level_label.text = ("Lvl: " + str(presentType.get("Level")[0]) + " -> " + str(presentType.get("Level")[0] + 1))
		if not newPresent:
			reward_bar.value = presentType.get("reward_money")[1]
			reward_bar_2.value = presentType.get("reward_jaffa")[1]
		else:
			reward_bar.value = 0
			reward_bar_2.value = 0
	
		updateBuffers()
	else:
		call_deferred("free")
		
func pickNew(from):
	return from.pick_random()
	
func pickUpgrade(from):
	return from.pick_random()

func appearPanel():	
	if tween:
		tween.kill()
	
	if PlayerVariables.playerJaffas < cost:
		upgrade.modulate = Color.RED
	else:
		upgrade.modulate = Color.WHITE
		
	tween = create_tween().parallel()
	if not newPresent:
		tween.parallel().tween_property(level, "scale", Vector2(1.25,1.25), .35).set_trans(Tween.TRANS_BACK)
	if presentTypeFinal.get("Unlocked") == false:
		get_parent().get_parent().get_parent().appearInfo(presentTypeFinal.get("name"), presentTypeFinal.get("info")) 
	tween.parallel().tween_property(upgrade, "scale", Vector2(1.25,1.25), .35).set_trans(Tween.TRANS_BACK)	
	tween.parallel().tween_property(animated_sprite_2d, "scale", Vector2(6,6), .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "scale:y", 1, .35).set_trans(Tween.TRANS_BACK).set_delay(.15)
	tween.parallel().tween_property(reward_bar, "scale:x", 1, .35).set_trans(Tween.TRANS_BACK).set_delay(.15)
	tween.parallel().tween_property(reward_bar_2, "scale:x", 1, .35).set_trans(Tween.TRANS_BACK).set_delay(.25)
	await tween.finished
	tweenFinished = true
	
func disappearPanel():
	tweenFinished = false
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.parallel().tween_property(animated_sprite_2d, "scale", Vector2(4,4), .35).set_trans(Tween.TRANS_BACK)
	if not bought:
		tween.parallel().tween_property(upgrade, "scale", Vector2(0,0), .35).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(level, "scale", Vector2(0,0), .35).set_trans(Tween.TRANS_BACK)
	get_parent().get_parent().get_parent().disappearInfo()
	tween.parallel().tween_property(panel, "scale:y", 0, .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(reward_bar, "scale:x", 0, .35).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(reward_bar_2, "scale:x", 0, .35).set_trans(Tween.TRANS_BACK)

func _on_control_mouse_entered() -> void:
	if not bought:
		appearPanel()
		inPanel = true

func _on_control_mouse_exited() -> void:
	disappearPanel()
	inPanel = false

func animateFloat(object):
	await get_tree().create_timer(randf_range(0,1)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "offset:y", -1, 2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(object, "offset:y", 0, 2).set_ease(Tween.EASE_IN).set_delay(2)
	
	tween.set_loops()
	
func animateRotation(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", 4, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -4, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()
	
func animateRotationLevel(object):
	await get_tree().create_timer(randf_range(0,1)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", -6, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -14, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()

func _on_progress_bar_value_changed(value: float) -> void:
	if value == 100:
		bumpJaffa()
		PlayerVariables.playerJaffas -= cost
		var temp = PresentStats.list.find(presentTypeFinal)
		if temp != -1:
			bought = true
			var conf = CONFETTIE_FOR_SHOP.instantiate()
			add_child(conf)
			conf.global_position = $upgrade/confMarker.global_position
			conf.emitting = true
			
			var tween = create_tween()
			tween.parallel().tween_property(level, "scale", Vector2(0,0),.35).set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(upgrade, "scale", Vector2(0,0),.35).set_trans(Tween.TRANS_BACK)
			var present = PresentStats.list[temp]
			
			if not newPresent:
				var pType = presentTypeFinal.get("ID")
				var sType = presentTypeFinal.get("StatID")
				var updatedStats = PresentUpgradeVariables.returnStats(sType, present.get("Level"))
				PresentStats.updateStats(pType, updatedStats)

				level_label.text = "Lvl: " + str(present.get("Level")[0])
			else:
				var dict = {"Unlocked" : true}
				present.merge(dict, true)
			updateMainBar(present.get("reward_money")[1],present.get("reward_jaffa")[1])
		
		progress_bar.value = 0
		PresentStats.updateList()
		if not newPresent:
			updateBuffers()

func _on_update_complete() -> void:
	await get_tree().create_timer(0.25).timeout
	onLevelUp()
