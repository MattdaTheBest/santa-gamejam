extends CharacterBody2D

const SPEED = 150
var accel = 50
var decel = 50
var currentSpeed = 0
var maxSpeed = 100
const SlowSPEED = 50
const maxVelocity = 50
@export var  maxTrailSize : int = 15

var playerMoney : int = 0
var playerJaffas : int = 0


var buttonDown : bool = false
var presentList = []
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
@onready var player_ui: CanvasLayer = $"../../playerUI"






func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:#
	#cash.text = str(playerMoney)
	#print(presentList.size())
	
	shot_power.value = shotPower
	
	var is_drifting = Input.is_action_pressed("spacebar")
	if is_drifting:
		turnSpeed = 250
		maxSpeed = 75
	else:
		turnSpeed = 150
		maxSpeed = 100
	
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
			
	if Input.is_action_pressed("leftClick") and not presentList.is_empty():
		if shotPower < 100:
			shotPower += shotBuildUp*shotBuildUp * delta
			
		if Input.is_action_just_pressed("rightClick"):
			shotCancel = true
	
	if Input.is_action_just_released("leftClick") and not presentList.is_empty():
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
	move_and_slide()

func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("present") and not presentList.has(area.get_parent()) and presentList.size() < maxTrailSize:
		if presentList.size() == 0:
			var present = area.get_parent()
			present.setModeTrailandTarget(self)
		else:
			var present = area.get_parent()
			present.setModeTrailandTarget(presentList[presentList.size() - 1])
		
		presentList.append(area.get_parent())
		player_ui.addPresent(area.get_parent().presentactual.frame, maxTrailSize - presentList.find(area.get_parent()))
		
func shootPresent(power):
	var present = presentList[0]
	presentList.remove_at(0)
	player_ui.call_deferred("removePresent")
	
	for i in presentList.size():
		if i == 0:
			presentList[i].setTarget(self)
		else:
			presentList[i].setTarget(presentList[i - 1])
	
	if present != null:	
		present.shootPresent(power)
		

func rotatePresentsRight():
	if presentList.size() > 1:
		var tempList = presentList.duplicate()
		for i in presentList.size():
			if i == 0:
				presentList[i].setTarget(presentList[presentList.size() - 1])
				presentList[i] = tempList[i + 1]
			elif i == 1:
				presentList[i].setTarget(self)
				if i == presentList.size() - 1:
					presentList[i] = tempList[0]	
				elif i + 1 <= presentList.size() - 1:
					presentList[i] = tempList[i + 1]
			elif i == presentList.size() - 1:
				presentList[i] = tempList[0]
			else:
				if i + 1 <= presentList.size() - 1:
					presentList[i] = presentList[i + 1]
				
func rotatePresentsLeft():
	if presentList.size() > 1:
		var tempList = presentList.duplicate()
		for i in presentList.size():
			var index = (presentList.size()) - (i + 1)
			if index == presentList.size() - 1:
				presentList[index].setTarget(self)
				presentList[index] = tempList[index - 1]
			elif index == 1:
				if index - 1 >= 0:
					presentList[index] = tempList[index - 1]
			elif index == 0:
				presentList[index].setTarget(tempList[presentList.size() - 1])
				presentList[index] = tempList[presentList.size() - 1]
			else:
				if index - 1 >= 0:
					presentList[index] = presentList[index - 1]

func updateSpriteAngle(): #16 frames
	currRotation = fmod(currRotation + 360, 360)
	direction = center.global_position.direction_to(offset.global_position)
	var frame_index = int(round(currRotation / 22.5)) % 16
	animated_sprite_2d.set_frame_and_progress(frame_index, 1)
	center.rotation_degrees = currRotation
	shadow.set_frame_and_progress(animated_sprite_2d.frame, 1)
	
func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("cash"):
		body.call_deferred("remove_from_group", "cash")
		body.call_deferred("reparent", self)
		playerMoney += body.value
		player_ui.updateMoney(playerMoney)
		body.pickupAnimation()
	elif body.is_in_group("jaffa"):
		body.call_deferred("remove_from_group", "jaffa")
		body.call_deferred("reparent", self)
		playerJaffas += body.value
		player_ui.updateJaffas(playerJaffas)
		body.pickupAnimation()

		
