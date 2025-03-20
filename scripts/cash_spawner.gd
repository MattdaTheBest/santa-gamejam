extends Node2D

const LOOSE_CASH = preload("res://scenes/loose_cash.tscn")
const STACKED_CASH = preload("res://scenes/stacked_cash.tscn")
const JAFFA = preload("res://scenes/jaffa.tscn")

var player
var jaffaChance = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("getPlayer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("e"):
		#spawnCash(5, 12)
	pass
	
func spawnCash(money, jaffas):
	var stacks = int(money/5)
	var loose = money - (stacks*5)
	var jaffa = jaffas
	
	for s in stacks:
		var stackedMoney = STACKED_CASH.instantiate()
		stackedMoney.global_position = global_position
		
		get_parent().get_parent().get_parent().add_child(stackedMoney)
		stackedMoney.set_linear_velocity(Vector2(randf_range(0,100),randf_range(0,100)) * global_position.direction_to(player.global_position))
		stackedMoney.set_angular_velocity((randf_range(-25,25)))
		stackedMoney.target = player
		
	for l in loose:
		var looseMoney = LOOSE_CASH.instantiate()
		looseMoney.global_position = global_position
		
		get_parent().get_parent().get_parent().add_child(looseMoney)
		looseMoney.set_linear_velocity(Vector2(randf_range(0,100),randf_range(0,100)) * global_position.direction_to(player.global_position))
		looseMoney.set_angular_velocity(randf_range(-25,25))
		looseMoney.target = player
	
	for j in jaffa:
		var jaffaCake = JAFFA.instantiate()
		jaffaCake.global_position = global_position
		
		get_parent().get_parent().get_parent().add_child(jaffaCake)
		jaffaCake.set_linear_velocity(Vector2(randf_range(0,100),randf_range(0,100)) * global_position.direction_to(player.global_position))
		jaffaCake.set_angular_velocity((randf_range(-25,25)))
		jaffaCake.target = player

func getPlayer():
	player = get_tree().get_nodes_in_group("player")[0]
