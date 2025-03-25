extends Node

var pauseMoneyLoss : bool = false
var christmasCheerXP : float = 75.0
var christmasCheetLVL : int = 7
var maxTrailSize: int = 1
var playerStartingMoney : int = 50
var playerMoney : int = 0
var playerJaffas : int = 0

var playerCurrLevelJaffas : int = 0
var playerCurrLevelCrashes : String = "00"
var playerCurrLevelTime : String = "00:00"

var presentList : Array = []

#func _process(delta: float) -> void:
	#print(playerMoney)
