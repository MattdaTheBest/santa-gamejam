extends CharacterBody2D

const SPEED = 150
var accel = 50
var decel = 50
var currentSpeed = 0
var maxSpeed = 100
const SlowSPEED = 50
const maxVelocity = 50

#@export var  maxTrailSize : int = 7
#var playerStartingMoney : int = 50
#var playerMoney : int = 0
#var playerJaffas : int = 0
#var presentList = []

var buttonDown : bool = false
var shotPower = 0
var shotBuildUp = 10
var shotBasePower = 75
var shotCancel : bool = false
var currRotation : float = 0.0
var turnSpeed : int = 150
var direction : Vector2
@onready var shot_power: ProgressBar = $shotPower
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var center: Marker2D = $Center
@onready var offset: Marker2D = $Center/Offset
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shadow: AnimatedSprite2D = $shadow
@onready var snow_trail: Line2D = $snowTrail
@onready var player_money_loss_timer: Timer = $playerMoneyLossTimer

func _ready() -> void:
	call_deferred("setUpValues")
	pass
	
func _physics_process(delta: float) -> void:#
	#cash.text = str(playerMoney)
	#print(presentList.size())

	$RayCast2D.rotation_degrees = currRotation
	$RayCast2D2.rotation_degrees = currRotation
		
	shot_power.value = shotPower
	
	if Input.is_action_just_pressed("spacebar"):
		if Input.is_action_pressed("shift"):
			PlayerUi.updateMoneyBufferAmount(-10)
			PlayerVariables.playerMoney -= 10
		else:
			PlayerUi.updateMoneyBufferAmount(10)
			PlayerVariables.playerMoney += 10
		#	player_ui.updateJaffaBufferAmount(10)
			#PlayerVariables.maxTrailSize += 1
	
	if Input.is_action_pressed("Left") and currentSpeed != 0:
		currRotation -= turnSpeed * abs(currentSpeed/100) * delta
		buttonDown = true
	if Input.is_action_pressed("Right") and currentSpeed != 0:
		currRotation += turnSpeed * abs(currentSpeed/100) * delta
		buttonDown = true
		
	if Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
		if Input.is_action_pressed("Up"):
			currentSpeed = clampf(currentSpeed + accel * delta, -maxSpeed, maxSpeed)
			buttonDown = true
		if Input.is_action_pressed("Down"):
			currentSpeed = clampf(currentSpeed - accel * delta, -maxSpeed, maxSpeed)
			buttonDown = true
	else:
		if currentSpeed > 0:
			currentSpeed = max(currentSpeed - decel * delta, 0)
		elif currentSpeed < 0:
			currentSpeed = min(currentSpeed + decel * delta, 0)
			
	if Input.is_action_pressed("leftClick") and not PlayerVariables.presentList.is_empty():
		if shotPower < 100:
			shotPower += shotBuildUp*shotBuildUp * delta
			
		if Input.is_action_just_pressed("rightClick"):
			shotCancel = true
	
	if Input.is_action_just_released("leftClick") and not PlayerVariables.presentList.is_empty():
		if shotCancel:
			shotCancel = false
		else:
			call_deferred("shootPresent",shotPower + shotBasePower)
			#shootPresent(shotPower + shotBasePower)
					
		shotPower = 0
		
	if Input.is_action_just_pressed("e"):
		rotatePresentsRight()
	if Input.is_action_just_pressed("q"):
		rotatePresentsLeft()

	updateSpriteAngle()
	velocity = currentSpeed * direction 
	if move_and_slide():
		if get_slide_collision_count() > 0 and ($RayCast2D.is_colliding() or $RayCast2D2.is_colliding()):
			currentSpeed = -currentSpeed/2
	updateTrail()

func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("present") and not PlayerVariables.presentList.has(area.get_parent()):
		var present = area.get_parent()
		if (PlayerVariables.presentList.size() < PlayerVariables.maxTrailSize) or (area.get_parent().presentType == "Void Present"):
			
			if (area.get_parent().presentType == "Void Present"):
				PlayerVariables.maxTrailSize += 1
			
			if PlayerVariables.presentList.size() == 0:
				present.setModeTrailandTarget(self)
			else:	
				present.setModeTrailandTarget(PlayerVariables.presentList[PlayerVariables.presentList.size() - 1])
			
			PlayerVariables.presentList.append(present)
			PlayerUi.addPresent(present.presentactual.frame, PlayerVariables.maxTrailSize - PlayerVariables.presentList.find(present), present,present.presentType )
				
func shootPresent(power):
	var present = PlayerVariables.presentList[0]
	PlayerVariables.presentList.remove_at(0)
	PlayerUi.call_deferred("removePresent", present)
	
	for i in PlayerVariables.presentList.size():
		if i == 0:
			PlayerVariables.presentList[i].setTarget(self)
		else:
			PlayerVariables.presentList[i].setTarget(PlayerVariables.presentList[i - 1])
	
	if present != null:	
		present.shootPresent(power)
		
func rotatePresentsRight():
	if PlayerVariables.presentList.size() > 1:
		var tempList = PlayerVariables.presentList.duplicate()
		for i in PlayerVariables.presentList.size():
			if i == 0:
				PlayerVariables.presentList[i].setTarget(PlayerVariables.presentList[PlayerVariables.presentList.size() - 1])
				PlayerVariables.presentList[i] = tempList[i + 1]
			elif i == 1:
				PlayerVariables.presentList[i].setTarget(self)
				if i == PlayerVariables.presentList.size() - 1:
					PlayerVariables.presentList[i] = tempList[0]	
				elif i + 1 <= PlayerVariables.presentList.size() - 1:
					PlayerVariables.presentList[i] = tempList[i + 1]
			elif i == PlayerVariables.presentList.size() - 1:
				PlayerVariables.presentList[i] = tempList[0]
			else:
				if i + 1 <= PlayerVariables.presentList.size() - 1:
					PlayerVariables.presentList[i] = PlayerVariables.presentList[i + 1]
	PlayerUi.sortPresents()
				
func rotatePresentsLeft():
	if PlayerVariables.presentList.size() > 1:
		var tempList = PlayerVariables.presentList.duplicate()
		for i in PlayerVariables.presentList.size():
			var index = (PlayerVariables.presentList.size()) - (i + 1)
			if index == PlayerVariables.presentList.size() - 1:
				PlayerVariables.presentList[index].setTarget(self)
				PlayerVariables.presentList[index] = tempList[index - 1]
			elif index == 1:
				if index - 1 >= 0:
					PlayerVariables.presentList[index] = tempList[index - 1]
			elif index == 0:
				PlayerVariables.presentList[index].setTarget(tempList[PlayerVariables.presentList.size() - 1])
				PlayerVariables.presentList[index] = tempList[PlayerVariables.presentList.size() - 1]
			else:
				if index - 1 >= 0:
					PlayerVariables.presentList[index] = PlayerVariables.presentList[index - 1]
	PlayerUi.sortPresents()

func updateSpriteAngle(): #16 frames
	currRotation = fmod(currRotation + 360, 360)
	direction = center.global_position.direction_to(offset.global_position)
	var frame_index = int(round(currRotation / 22.5)) % 16
	animated_sprite_2d.set_frame_and_progress(frame_index, 1)
	center.rotation_degrees = currRotation
	shadow.set_frame_and_progress(animated_sprite_2d.frame, 1)
	
func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("cash"):
		PlayerVariables.playerMoney += body.value
		PlayerUi.cash.text = str(PlayerVariables.playerMoney)
		PlayerUi.updateMoneyBufferAmount(body.value)
		body.call_deferred("remove_from_group", "cash")
		body.pickupAnimation()
	elif body.is_in_group("jaffa"):
		PlayerUi.updateJaffaBufferAmount(body.value)
		body.call_deferred("remove_from_group", "jaffa")
		#body.call_deferred("reparent", self)
		PlayerVariables.playerCurrLevelJaffas += body.value
		#player_ui.updateJaffas(playerJaffas)

		body.pickupAnimation()

func updateTrail():
	if snow_trail.get_point_count() >= 200 or velocity == Vector2(0,0) and snow_trail.get_point_count() > 0:
		snow_trail.remove_point(0)
	if velocity != Vector2(0,0):
		snow_trail.add_point(global_position)
		
	#snow_trail.rotation_degrees = rotation_degrees

func setUpValues():
	PlayerVariables.maxTrailSize = PlayerVariables.christmasCheetLVL + 1
	PlayerVariables.playerMoney += PlayerVariables.playerStartingMoney
	PlayerUi.cash.text = str(PlayerVariables.playerMoney)
	PlayerUi.updateMoneyBufferAmount(PlayerVariables.playerStartingMoney)
	
	PlayerVariables.playerCurrLevelJaffas += 5
	PlayerUi.updateJaffaBufferAmount(5)
	await get_tree().create_timer(5).timeout
	player_money_loss_timer.start()
	player_money_loss_timer.autostart = true	
