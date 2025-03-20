extends Control

var addAmount : int = 0
var pointBufferValue : float = 0
var pointBufferValueTEMP : float = 0
var pointActual : float = 0
@onready var actual: TextureProgressBar = $Actual
@onready var buffer: TextureProgressBar = $Actual/Buffer
@onready var buffer_timer: Timer = $Actual/bufferTimer
@onready var gpu_particles_2d: GPUParticles2D = $Actual/GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $Actual/GPUParticles2D2
@onready var xmas_cheer: PanelContainer = $xmasCheer
@onready var marker: PanelContainer = $marker
@onready var progress_label: Label = $marker/progressLabel
@onready var level: PanelContainer = $level
@onready var level_label: Label = $level/levelLabel

@onready var money_path: Path2D = $Node2D/moneyPath
@onready var a: Marker2D = $Node2D/A
@onready var b: Marker2D = $Node2D/B
@onready var c: Marker2D = $Node2D/C
const END_SCREEN_MONEY = preload("res://end_screen_money.tscn")

@onready var jaffa_count: PanelContainer = $JaffaCount
@onready var jaffa_count_label: Label = $JaffaCount/JaffaCountLabel

@onready var time_to_complete: PanelContainer = $timeToComplete
@onready var time_to_complete_label: Label = $timeToComplete/timeToCompleteLabel

@onready var crash_counter: PanelContainer = $CrashCounter
@onready var crash_counter_label: Label = $CrashCounter/CrashCounterLabel

@onready var home_screen_button: PanelContainer = $mainMenu
@onready var home_screen_button_label: Label = $mainMenu/mainMenuLabel

@onready var to_shop: PanelContainer = $ToShop
@onready var to_shop_label: Label = $ToShop/toShopLabel

@onready var exit: PanelContainer = $exit
@onready var exit_label: Label = $exit/exitLabel

const WORLD_TEST = preload("res://test.tscn")
const WORLD_2 = preload("res://scenes/world_2.tscn")
const SHOP_SCENE = preload("res://shop_scene.tscn")

var tweenMenuButton
var tweenShopButton
var tweenExitButton

const SPRITE_BORDERED = preload("res://sprites/UI/spriteBordered.png")
const JAFFA = preload("res://sprites/UI/jaffaBordered.png")

var playerMoneyLocal : int = 0
var playerXPLocal : int = 0
var playerLvlLocal : int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animateRotation(actual)
	animateFloat(actual)
	animateRotation(xmas_cheer)
	animateFloat(xmas_cheer)
	animateFloat(level)
	animateRotation(actual)
	animateFloat(actual)
	animateRotation(jaffa_count)
	animateFloat(jaffa_count)
	animateRotation(time_to_complete)
	animateFloat(time_to_complete)
	animateRotation(crash_counter)
	animateFloat(crash_counter)
	animateRotation(home_screen_button)
	animateRotation(to_shop)
	animateRotation(exit)
	getCurrentCheer()
	updatePlayerMoney()
	xmas_cheer.position.x = 224 - xmas_cheer.pivot_offset.x
	jaffa_count.position.x = actual.position.x
	jaffa_count.position.y = actual.position.y + 60
	jaffa_count.size.x = actual.size.x
	time_to_complete.position.x = actual.position.x
	time_to_complete.position.y = actual.position.y + 120
	time_to_complete.size.x = actual.size.x
	crash_counter.position.x = actual.position.x
	crash_counter.position.y = actual.position.y + 180
	crash_counter.size.x = actual.size.x
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("q"):
	#	Appear()
		#var tween = create_tween()
		#tween.parallel().tween_property(home_screen_button, "scale", Vector2(3.125,3.125), .15).set_trans(Tween.TRANS_BACK)
		home_screen_button.scale += Vector2(1,1)

	updateParticlesandMarker()
	if PlayerVariables.playerJaffas < 10:
		jaffa_count_label.text = "Jaffas                                                                          " + "0" + str(PlayerVariables.playerJaffas)
	else:
		jaffa_count_label.text = "Jaffas                                                                          " + str(PlayerVariables.playerJaffas)
		
	$RichTextLabel.global_position = Vector2(jaffa_count.global_position.x + 50, jaffa_count.global_position.y + 6)
	$RichTextLabel.rotation_degrees = jaffa_count.rotation_degrees
	$RichTextLabel2.global_position = Vector2(time_to_complete.global_position.x + 36, time_to_complete.global_position.y + 6)
	$RichTextLabel2.rotation_degrees = time_to_complete.rotation_degrees
	$RichTextLabel3.global_position = Vector2(crash_counter.global_position.x + 54, crash_counter.global_position.y + 6)
	$RichTextLabel3.rotation_degrees = crash_counter.rotation_degrees
	home_screen_button.global_position = Vector2(get_parent().level_end_screen_con.global_position.x + get_parent().level_end_screen_con.size.x/2 - (home_screen_button.size.x/2 * home_screen_button.scale.x), get_parent().level_end_screen_con.global_position.y + get_parent().level_end_screen_con.size.y - home_screen_button.size.y/2) 
	to_shop.global_position = Vector2(get_parent().level_end_screen_con.global_position.x + (get_parent().level_end_screen_con.size.x/3 * 2) - (to_shop.size.x/2 * to_shop.scale.x), get_parent().level_end_screen_con.global_position.y + get_parent().level_end_screen_con.size.y - to_shop.size.y/2)
	exit.global_position = Vector2(get_parent().level_end_screen_con.global_position.x + (get_parent().level_end_screen_con.size.x/3 ) - (exit.size.x/2 * exit.scale.x), get_parent().level_end_screen_con.global_position.y + get_parent().level_end_screen_con.size.y - exit.size.y/2)

func optionsAppear():
	var tween = create_tween()
	
	tween.tween_property(home_screen_button, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(to_shop, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(.55)
	tween.parallel().tween_property(exit, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(.55)

func CCApear():
	$RichTextLabel3.text = "[wave amp=20 freq=6][center]" + " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . "
	crash_counter_label.text = "Crashes                                                                         " + str(PlayerVariables.playerCurrLevelCrashes)
	get_parent().expandEndScreen()
	var tween = create_tween()	
	
	tween.parallel().tween_property(crash_counter, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property($RichTextLabel3, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	await tween.finished
	await get_tree().create_timer(0.5).timeout

func TTCApear():
	$RichTextLabel2.text = "[wave amp=20 freq=6][center]" + " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . "
	time_to_complete_label.text = "Time                                                                          " + str(PlayerVariables.playerCurrLevelTime)
	get_parent().expandEndScreen()
	var tween = create_tween()	
	
	tween.parallel().tween_property(time_to_complete, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property($RichTextLabel2, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	CCApear()
	
func jaffaAppear():
	get_parent().expandEndScreen()
	var tween = create_tween()	
	
	tween.parallel().tween_property(jaffa_count, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property($RichTextLabel, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK)
	await tween.finished
	emptyJaffas()
	
func emptyJaffas():
	
	$RichTextLabel.text = "[wave amp=20 freq=6][center]" + " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . "
	
	$Node2D/B.global_position.y = jaffa_count.global_position.y + 14
	$Node2D/C.global_position.y = jaffa_count.global_position.y + 14
	
	money_path.curve.clear_points()
	createMoneyPath(a.position,b.position,c.position)
	
	var tween = create_tween()
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "scale", Vector2(1.25,1.25), 1).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "rotation_degrees", -10, 1).set_trans(Tween.TRANS_BACK)
	await tween.finished
	
	var jaffas = PlayerVariables.playerCurrLevelJaffas
	for n in jaffas:
		PlayerVariables.playerCurrLevelJaffas -= 1
		get_parent().get_parent().label_current_jafs.text = "       $ " + str(PlayerVariables.playerCurrLevelJaffas)
		var jaffa = END_SCREEN_MONEY.instantiate()
		jaffa.call_deferred("setTexture", JAFFA)
		money_path.add_child(jaffa)
		jaffa.progress = 0
		jaffa.goJaffa()
		await get_tree().create_timer(0.0625).timeout
		
	tween = create_tween()	
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "scale", Vector2(1,1), 1).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "rotation_degrees", 0, 1).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	TTCApear()

func Appear():
	
	PlayerVariables.pauseMoneyLoss = true
	var tween = create_tween()
	tween.tween_property(xmas_cheer, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(actual, "scale", Vector2(1,1),.55).set_trans(Tween.TRANS_BACK).set_delay(.6)
	
	tween.parallel().tween_property(level, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(.6)
	tween.parallel().tween_property(marker, "scale", Vector2(1,1), .55).set_trans(Tween.TRANS_BACK).set_delay(.6)
	
	tween.parallel().tween_property($Actual/GPUParticles2D2, "modulate:a", 1, .35).set_delay(1)
	tween.parallel().tween_property($Actual/GPUParticles2D, "modulate:a", 1, .35).set_delay(1)
	tween.parallel().tween_property($Actual/GPUParticles2D/GPUParticles2D2, "modulate:a", 1, .35).set_delay(1)
	tween.parallel().tween_property($Actual/GPUParticles2D/GPUParticles2D, "modulate:a", 1, .35).set_delay(1)
	
	await tween.finished
	positionPiggyBank()
	await get_tree().create_timer(.85).timeout
	createMoneyPath(a.position,b.position,c.position)

	emptyPiggyBank()
	

func updatePlayerMoney():
	
	playerMoneyLocal = PlayerVariables.playerMoney
	playerXPLocal = PlayerVariables.christmasCheerXP
	playerLvlLocal = PlayerVariables.christmasCheetLVL
	
	PlayerVariables.christmasCheetLVL += int(PlayerVariables.playerMoney/100)
	PlayerVariables.christmasCheerXP += int(PlayerVariables.playerMoney%100)
	
	if PlayerVariables.christmasCheerXP >= 100:
		PlayerVariables.christmasCheetLVL += 1
		PlayerVariables.christmasCheerXP -= 100
	
	PlayerVariables.playerMoney = 0
			
func createMoneyPath(p0: Vector2, p1: Vector2, p2: Vector2,):
	money_path.curve.clear_points()
	var t = 0.0
	while t < 1:
		var q0 = p0.lerp(p1, t)
		var q1 = p1.lerp(p2, t)
		var r = q0.lerp(q1, t)
		t += .01
		money_path.curve.add_point(r)

func emptyPiggyBank():
	var loopAmount = 0.001
	var amount = playerMoneyLocal
	var piggyScale = get_parent().get_parent().money_ui.scale
	for n in amount:
		playerMoneyLocal -= 1
		var money = END_SCREEN_MONEY.instantiate()
		money.call_deferred("setTexture", SPRITE_BORDERED)
		money_path.add_child(money)
		money.progress = 0
		money.go()
		await get_tree().create_timer(0.0625 - loopAmount).timeout
		pointBufferValueTEMP += 1
		loopAmount += 0.001
		get_parent().get_parent().label_current.text = "       $ " + str(playerMoneyLocal)
		
		if int(pointBufferValueTEMP) % 100 == 0 or playerMoneyLocal == 0:
			var tween = create_tween()
			tween.parallel().tween_property(get_parent().get_parent().money_ui, "scale", Vector2(1,1), 1).set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(get_parent().get_parent().money_ui, "rotation_degrees", 0, .25).set_trans(Tween.TRANS_BACK)
			break
			
func positionPiggyBank():
	get_parent().get_parent().collapseMoneyBufferLabel()
	get_parent().get_parent().collapseJaffaBufferLabel()
	var tween = create_tween()
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "scale", Vector2(1.25,1.25), 1).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(get_parent().get_parent().money_ui, "rotation_degrees", -10, 1).set_trans(Tween.TRANS_BACK)
	
	$Node2D/B.global_position.x = get_parent().get_parent().money_ui.global_position.x
	$Node2D/A.global_position = get_parent().get_parent().money_ui.global_position + Vector2(20,0)

func updateParticlesandMarker():
	gpu_particles_2d.position.x = actual.value * 4.48
	gpu_particles_2d_2.position.x = (actual.value * 4.48)/2
	gpu_particles_2d_2.process_material.emission_box_extents.x = (actual.value * 4.48)/2
	marker.position = marker.position.lerp(Vector2(actual.value * 4.48 - marker.pivot_offset.x, actual.position.y + (marker.pivot_offset.y + 32)), 8 * get_process_delta_time())
	if actual.value != 100:
		marker.size = Vector2(21,43)
		
	progress_label.text = str(int(actual.value))
	level_label.text = "LVL: " + str(playerLvlLocal)

func getCurrentCheer():
	pointActual = PlayerVariables.christmasCheerXP
	actual.value = pointActual
	pointBufferValueTEMP = pointActual

func updatePointBufferAmount(value):
	pointBufferValue += value
	buffer.value = pointBufferValue + pointActual
	buffer_timer.start(.125)

func countDownPoints():
	animateProgressLabel()
	await get_tree().create_timer(0.0).timeout
	if pointBufferValue > 0:
		pointBufferValue -= .25
		pointActual += .25
		actual.value = pointActual
		
		if pointActual >= 100:
			xpBump()
			popLevel()
			playerLvlLocal += 1
			buffer.value = pointBufferValue
			pointActual = 0
			if pointBufferValueTEMP != 0:
				positionPiggyBank()
				await get_tree().create_timer(.85).timeout
				emptyPiggyBank()
	
	if pointBufferValue > 0 and buffer_timer.is_stopped():
		countDownPoints()

	actual.value = pointActual
	#PlayerVariables.christmasCheerXP = pointActual
	animateProgressLabel()

func popLevel():
	var tween = create_tween()
	
	tween.tween_property(level, "scale", Vector2(1.25,1.25), .25).set_trans(Tween.TRANS_BACK)
	tween.tween_property(level, "scale", Vector2(1,1), .15).set_trans(Tween.TRANS_BACK)
		
func _on_buffer_timer_timeout() -> void:
	countDownPoints()

func xpBump():
	var tween = create_tween()
	
	tween.tween_property(actual, "scale", Vector2(1.125,1.125), .25).set_trans(Tween.TRANS_BACK)
	tween.tween_property(actual, "scale", Vector2(1,1), .15)
	
func animateRotation(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.tween_property(object, "rotation_degrees", 1, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	tween.tween_property(object, "rotation_degrees", -1, 2.5).set_ease(Tween.EASE_OUT_IN )
	tween.tween_property(object, "rotation_degrees", 0, 1.25).set_ease(Tween.EASE_IN)
	
	tween.set_loops()
	
func animateFloat(object):
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(object, "position:y", object.position.y - 3, 2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(object, "position:y",object.position.y + 3, 2).set_ease(Tween.EASE_IN).set_delay(2)
	
	tween.set_loops()

func animateProgressLabel():
	if pointBufferValue > 0 and marker.rotation_degrees == 0:
		var tween = create_tween()
		tween.tween_property(marker, "rotation_degrees", 25, .65).set_trans(Tween.TRANS_BACK)
		
		#marker.rotation_degrees = lerpf(marker.rotation_degrees, -25, get_process_delta_time() * 4)
	elif pointBufferValue == 0:
		var tween = create_tween()
		tween.tween_property(marker, "rotation_degrees", 0, .65).set_trans(Tween.TRANS_BACK)
		#marker.rotation_degrees = lerpf(marker.rotation_degrees, 0, get_process_delta_time() * 4)

func animateRotationLevel():
	await get_tree().create_timer(randf_range(0,1.75)).timeout
	var tween = create_tween()
	
	tween.parallel().tween_property(level, "rotation_degrees", -13, 2.5).set_ease(Tween.EASE_IN)
	
	tween.parallel().tween_property(level, "rotation_degrees",  -17, 2.5).set_ease(Tween.EASE_IN).set_delay(2.5)
	
	tween.set_loops()

func _on_actual_value_changed(value: float) -> void:
	if playerMoneyLocal == 0 and actual.value == buffer.value:
		await get_tree().create_timer(0.5).timeout
		var tween = create_tween()
		tween.tween_property(marker, "scale", Vector2(0,0), .35).set_trans(Tween.TRANS_BACK)
		await tween.finished
		jaffaAppear()
		
func _on_main_menu_button_mouse_entered() -> void:
	if tweenMenuButton:
		tweenMenuButton.kill()

	tweenMenuButton = create_tween()

	tweenMenuButton.parallel().tween_property(home_screen_button, "scale", Vector2(1.125,1.125), .15).set_trans(Tween.TRANS_BACK)
	#tweenMenuButton.parallel().tween_property(home_screen_button, "rotation_degrees", randf_range(-5,5), .15).set_trans(Tween.TRANS_BACK)


func _on_main_menu_button_mouse_exited() -> void:
	if tweenMenuButton:
		tweenMenuButton.kill()
		
	tweenMenuButton = create_tween()
	
	tweenMenuButton.tween_property(home_screen_button, "scale", Vector2(1,1), .05).set_trans(Tween.TRANS_BACK)
	#tweenMenuButton.parallel().tween_property(home_screen_button, "rotation_degrees", 0, .15).set_trans(Tween.TRANS_BACK)


func _on_to_shop_button_mouse_entered() -> void:
	if tweenShopButton:
		tweenShopButton.kill()

	tweenShopButton = create_tween()

	tweenShopButton.parallel().tween_property(to_shop, "scale", Vector2(1.125,1.125), .15).set_trans(Tween.TRANS_BACK)
	#tweenShopButton.parallel().tween_property(to_shop, "rotation_degrees", randf_range(-5,5), .15).set_trans(Tween.TRANS_BACK)


func _on_to_shop_button_mouse_exited() -> void:
	if tweenShopButton:
		tweenShopButton.kill()
		
	tweenShopButton = create_tween()
	
	tweenShopButton.tween_property(to_shop, "scale", Vector2(1,1), .05).set_trans(Tween.TRANS_BACK)
	#tweenShopButton.parallel().tween_property(to_shop, "rotation_degrees", 0, .15).set_trans(Tween.TRANS_BACK)


func _on_exit_button_mouse_entered() -> void:
	if tweenExitButton:
		tweenExitButton.kill()

	tweenExitButton = create_tween()

	tweenExitButton.parallel().tween_property(exit, "scale", Vector2(1.125,1.125), .15).set_trans(Tween.TRANS_BACK)
	#tweenExitButton.parallel().tween_property(exit, "rotation_degrees", randf_range(-5,5), .15).set_trans(Tween.TRANS_BACK)


func _on_exit_button_mouse_exited() -> void:
	if tweenExitButton:
		tweenExitButton.kill()
		
	tweenExitButton = create_tween()
	
	tweenExitButton.tween_property(exit, "scale", Vector2(1,1), .05).set_trans(Tween.TRANS_BACK)
	#tweenExitButton.parallel().tween_property(exit, "rotation_degrees", 0, .15).set_trans(Tween.TRANS_BACK)


func _on_main_menu_button_pressed() -> void:
	#SceneTransition.fadeIN()
	get_tree().quit()

func _on_to_shop_button_pressed() -> void:
	#SceneTransition.fadeIN()
	#get_parent().get_parent().scene_transition.fadeIN()
	#SceneTransition.fadeIN()
	#await get_tree().create_timer(3).timeout
	#get_tree().change_scene_to_packed(WORLD_TEST)
	#get_parent().close()
	SceneTransition.call_deferred("changeSceneNOUI", SHOP_SCENE)
	await get_tree().create_timer(1.5).timeout
	get_parent().call_deferred("free")
	#SceneTransition.changeScene(WORLD_2)

func _on_exit_button_pressed() -> void:
	#SceneTransition.fadeIN()
	get_tree().quit()
