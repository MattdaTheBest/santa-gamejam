extends CharacterBody2D

enum modes {pickup, trail, projectile, adjusting}
var currMode = modes.pickup
var direction : Vector2
@export var shotSpeed : float = 100.0
@export var slowSpeed : float = 120.0
@export var target : Node2D = null
@export var followSpeed = 120
@export var follorDistance = 14
@onready var pickup_area: Area2D = $pickupArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shadow: Sprite2D = $shadow
@onready var shoot_particles: GPUParticles2D = $shootParticles
@onready var allowable_gap = 25
@onready var follow_stop_delay: Timer = $follow_stop_delay
var tween
var finalVel

#Unique Present Variables -> updated through PresentStats script
@onready var presentactual: AnimatedSprite2D = $presentactual
var presentType = "Unset"
var presentMass : int = 0 
var presentMoneyReward : int = 0
var presentJaffaReward : int = 0
var bounceVariable : int = 2

const VOID_PARTICLES = preload("res://void_particles.tscn")
const RAINBOW_TRAIL = preload("res://rainbow_trail.tscn")
var parcticle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawnPresent()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if currMode == modes.trail:
		followTarget(delta)
	elif currMode == modes.projectile:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())/bounceVariable
			presentactual.rotation = -presentactual.rotation
		
		velocity = velocity.move_toward(Vector2(0,0), (slowSpeed + presentMass) * delta)
		
		if velocity == Vector2(0,0):
			if presentType == "Boomarang Present" and PlayerVariables.presentList.size() < PlayerVariables.maxTrailSize:
				doUniqueBoomarang()
			else:
				setModePickup()	
	
	if velocity.length() < 0.01:
		velocity = Vector2.ZERO
	
	move_and_slide()
	spinBoomarang()
	
func doUniqueBoomarang():
	shoot_particles.emitting = false
	if PlayerVariables.presentList.size() == 0:
		setModeTrailandTarget($"../../player")
	else:	
		setModeTrailandTarget(PlayerVariables.presentList[PlayerVariables.presentList.size() - 1])
		
	PlayerVariables.presentList.append(self)
	PlayerUi.addPresent(presentactual.frame, PlayerVariables.maxTrailSize - PlayerVariables.presentList.find(self), self,presentType)
	
	if global_position.distance_to(target.global_position) > 100:
		$CollisionShape2D.set_deferred("disabled", true)
		
		await get_tree().create_timer(.5).timeout
		
		$CollisionShape2D.set_deferred("disabled", false)

func spinBoomarang():
	if presentType == "Boomarang Present" and currMode == modes.projectile:
		presentactual.rotation_degrees += 20
			

func setPresentStats(stats : Dictionary):
	#presentactual.set_frame_and_progress(randi_range(stats.get("texture_index")[0],stats.get("texture_index")[1]), 1)
	#presentType = stats.get("name")
	#presentMass = stats.get("mass")
	#presentMoneyReward = randi_range(stats.get("reward_money")[0],stats.get("reward_money")[1])
	#presentJaffaReward = randi_range(stats.get("reward_jaffa")[0],stats.get("reward_jaffa")[1])
	
	presentactual.set_frame_and_progress(stats.get("texture_index"), 1)
	presentType = stats.get("name")
	presentMass = stats.get("mass")
	presentMoneyReward = stats.get("reward_money")
	presentJaffaReward = stats.get("reward_jaffa")
	
func spawnPresent():
	#current odds of a special present = 1/16
	#var present_type = randi_range(1,16)
	#if present_type != 16:
		#spawnBasic()
	#elif present_type == 16:
		#spawnRare()
	spawnRare()

func spawnBasic():
	var present_type = randi_range(0,5)
	if present_type == 0:
		setPresentStats(PresentStats.newBasic0())
	elif present_type == 1:
		setPresentStats(PresentStats.newBasic1())
	elif present_type == 2:
		setPresentStats(PresentStats.newBasic2())
	elif present_type == 3:
		setPresentStats(PresentStats.newBasic3())
	elif present_type == 4:
		setPresentStats(PresentStats.newBasic4())
	elif present_type == 5:
		setPresentStats(PresentStats.newBasic5())
		
	animation_player.advance(randf_range(0,2.5))
		
func spawnRare():
	var present_type = randi_range(1,6)
	if present_type == 1 and PresentStats.goldPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newGold())
	elif present_type == 2 and PresentStats.jaffaPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newJaffa())
	elif present_type == 3 and PresentStats.rainbowPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newRainbow())
		parcticle = RAINBOW_TRAIL.instantiate()
		get_parent().call_deferred("add_child",parcticle)
		parcticle.setPresentActual(self)
	elif present_type == 4 and PresentStats.bouncyPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newBouncy())
		bounceVariable = 1
	elif present_type == 5 and PresentStats.boomarangPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newBoomarang())
	elif present_type == 6 and PresentStats.voidPresent.get("Unlocked") == true:
		setPresentStats(PresentStats.newVoid())
		parcticle = VOID_PARTICLES.instantiate()
		add_child(parcticle)
		parcticle.setPresentActual(presentactual)
	else:
		spawnRare()
		
	animation_player.advance(randf_range(0,2.5))

func setModePickup():
	remove_collision_exception_with(target)
	set_collision_layer_value(4, false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(3,true)
	shoot_particles.emitting = false
	fixRotation()
	animation_player.play()
	currMode = modes.pickup
	pickup_area.monitorable = true
	pickup_area.monitoring = true
func setModeTrailandTarget(newTraget):
	pickupAnimation()
	set_collision_layer_value(4, false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3,false)
	currMode = modes.trail
	target = newTraget
func setModeTrail():
	pickupAnimation()
	set_collision_layer_value(4, false)
	set_collision_mask_value(4,false)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3,false)
	currMode = modes.trail
func setModeProjectile():
	currMode = modes.projectile
	
func shootPresent(speed):
	if presentType == "Void Present":
		PlayerVariables.maxTrailSize -= 1
		
	set_collision_layer_value(4, true)
	set_collision_mask_value(4,true)
	add_collision_exception_with(target)
	pickup_area.monitorable = false
	pickup_area.monitoring = false
	shotSpeed = speed
	presentactual.look_at(get_global_mouse_position())
	presentactual.rotation_degrees -= 90
	shadow.look_at(get_global_mouse_position())
	animation_player.stop()
	#global_position = global_position.lerp(target.global_position, 1)
	global_position = target.global_position
	direction = presentactual.global_position.direction_to(get_global_mouse_position())
	shoot_particles.emitting = true
	velocity = direction * shotSpeed
	setModeProjectile()
		
func setTarget(newTraget):
	target = newTraget
	
func followTarget(delta):
	if target != null and global_position.distance_to(target.global_position) > follorDistance:
		
		velocity += velocity.lerp(target.global_position - global_position, followSpeed * delta)		
		velocity += global_position.distance_to(target.global_position) * delta * (target.global_position - global_position) * 8
		
		if not tween.is_running():
			if global_position.x > target.global_position.x:
				presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, 25, delta * 2)
			elif global_position.x < target.global_position.x:
				presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, -25, delta * 2)
			
	else:
		if not tween.is_running():	
			presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, 0, delta * 2)
		
		velocity = velocity.lerp(Vector2(0,0), 8 * delta)
	
func fixRotation():
	
	if tween:
		tween.kill()

	tween = get_tree().create_tween()
		
	tween.parallel().tween_property(presentactual, "rotation_degrees", 0, .65).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(shadow, "rotation_degrees", 0, .65).set_trans(Tween.TRANS_BACK)

func pickupAnimation():
	
	if tween:
		tween.kill()
		
	tween = get_tree().create_tween()
		
	tween.parallel().tween_property(presentactual, "rotation_degrees", 360, .65).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(presentactual, "scale", Vector2(1.55,1.55), .15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(presentactual, "scale", Vector2(1,1), .35).set_delay(0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(presentactual, "rotation_degrees", 0, 0).set_trans(Tween.TRANS_BACK)
