extends CharacterBody2D

enum modes {pickup, trail, projectile, adjusting}
var currMode = modes.pickup
var direction : Vector2
@export var shotSpeed : float = 100.0
@export var slowSpeed : float = 120.0
@export var target : Node2D = null
@export var followSpeed = 100
@export var follorDistance = 8
@onready var pickup_area: Area2D = $pickupArea
@onready var presentactual: AnimatedSprite2D = $presentactual
@onready var shadow: Sprite2D = $shadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_particles: GPUParticles2D = $shootParticles
@onready var allowable_gap = 25
@onready var follow_stop_delay: Timer = $follow_stop_delay
var presentType = "Unset"
var tween

#Unique Present Variables
var presentMass : int = 0 
var presentMoneyReward : Array = [randi_range(5, 10), 0]





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
			velocity = velocity.bounce(collision_info.get_normal())/2
			presentactual.rotation = -presentactual.rotation
		
		velocity = velocity.move_toward(Vector2(0,0), (slowSpeed + presentMass) * delta)
		
		if velocity == Vector2(0,0):
			setModePickup()	

	move_and_slide()

func spawnPresent():
	#current odds of a special present = 1/16
	var present_type = randi_range(1,16)
	if present_type != 16:
		presentactual.set_frame_and_progress(randi_range(0,5),1)
		presentType = "Basic"
	elif present_type == 16:
		present_type = randi_range(1,2)
		if present_type == 1:
			presentactual.set_frame_and_progress(6,1)
			presentType = "Gold"
			
			presentMass = 50
			presentMoneyReward = [randi_range(10, 20),0]
		elif present_type == 2:
			presentactual.set_frame_and_progress(7,1)
			presentType = "Jaffa"
			
			presentMass = 0
			presentMoneyReward = [randi_range(0, 0), randi_range(2,3)]

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
		
		if not tween.is_running():
			if global_position.x > target.global_position.x:
				presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, 25, delta * 2)
			elif global_position.x < target.global_position.x:
				presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, -25, delta * 2)
			
	else:
		if not tween.is_running():	
			presentactual.rotation_degrees = lerpf(presentactual.rotation_degrees, 0, delta * 2)
		
		velocity = velocity.lerp(Vector2(0,0), followSpeed/4 * delta)
	
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
