extends Node

var basicPresent0 = {
	"name" : "Basic Present",
	"ID" : "basic0",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [0,0],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresent1 = {
	"name" : "Basic Present",
	"ID" : "basic1",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [1,1],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresent2 = {
	"name" : "Basic Present",
	"ID" : "basic2",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [2,2],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresent3 = {
	"name" : "Basic Present",
	"ID" : "basic3",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [3,3],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresent4 = {
	"name" : "Basic Present",
	"ID" : "basic4",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [4,4],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresent5 = {
	"name" : "Basic Present",
	"ID" : "basic5",
	"StatID" : "basic",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [5,5],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var goldPresent = {
	"name" : "Gold Present",
	"ID" : "gold",
	"StatID" : "gold",
	"Unlocked" : false,
	"Level" : [1],
	"texture_index" : [6,6],
	"mass" : 50,
	"reward_money" : [10,20],
	"reward_jaffa" : [0,0],
	"info" : "A golden present! This will provide more money, but wont go quite as far."
}

var jaffaPresent = {
	"name" : "Jaffa Present",
	"ID" : "jaffa",
	"StatID" : "jaffa",
	"Unlocked" : false,
	"Level" : [1],
	"texture_index" : [7,7],
	"mass" : 0,
	"reward_money" : [0,0],
	"reward_jaffa" : [2,3],
	"info" : "A Box of Jaffas! The best way to get jaffas for more upgrades! And then test good."
}

var rainbowPresent = {
	"name" : "Rainbow Present",
	"ID" : "rainbow",
	"StatID" : "rainbow",
	"Unlocked" : true,
	"Level" : [1],
	"texture_index" : [8,8],
	"mass" : 0,
	"reward_money" : [3,5],
	"reward_jaffa" : [0,0],
	"info" : "Rainbow? Yeah, Rainbow. Anyone will take this present, even if they have a color preference!"
}

var bouncyPresent = {
	"name" : "Bouncy Present",
	"ID" : "bouncy",
	"StatID" : "bouncy",
	"Unlocked" : false,
	"Level" : [1],
	"texture_index" : [9,9],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0],
	"info" : "Bounce! Bounce! Bounce! Thats all it does. It bounces just a little more!"
}

var boomarangPresent = {
	"name" : "Boomarang Present",
	"ID" : "boomarang",
	"StatID" : "boomarang",
	"Unlocked" : false,
	"Level" : [1],
	"texture_index" : [10,10],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0],
	"info" : "Goodday mate, this trusty present will come right back to you if you miss!"
}

var voidPresent = {
	"name" : "Void Present",
	"ID" : "void",
	"StatID" : "void",
	"Unlocked" : false,
	"Level" : [1],
	"texture_index" : [11,11],
	"mass" : 0,
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0],
	"info" : "Straight from the void! This present wont take up any space in your present trail!"
}

var snowmanPresent = {
	"name" : "Snowman Head",
	"ID" : "snowman",
	"StatID" : "snowman",
	"Unlocked" : true,
	"Level" : null,
	"texture_index" : [12,12],
	"mass" : null,
	"reward_money" : null,
	"reward_jaffa" : null,
	"info" : null,
	"useless" : true
}

var coalPresent = {
	"name" : "Chunk of Coal",
	"ID" : "coal",
	"StatID" : "coal",
	"Unlocked" : true,
	"Level" : null,
	"texture_index" : [13,13],
	"mass" : null,
	"reward_money" : null,
	"reward_jaffa" : null,
	"info" : null,
	"useless" : true
}

var list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateList()

func updateStats(pType, values):
	if values != null:
		if pType == "basic0":
			basicPresent0.merge(values, true)
		elif pType == "basic1":
			basicPresent1.merge(values, true)	
		elif pType == "basic2":
			basicPresent2.merge(values, true)
		elif pType == "basic3":
			basicPresent3.merge(values, true)
		elif pType == "basic4":
			basicPresent4.merge(values, true)
		elif pType == "basic5":
			basicPresent5.merge(values, true)
		elif pType == "gold":
			goldPresent.merge(values, true)
		elif pType == "jaffa":
			jaffaPresent.merge(values, true)
		elif pType == "rainbow":
			rainbowPresent.merge(values, true)
		elif pType == "bouncy":
			bouncyPresent.merge(values, true)
		elif pType == "boomarang":
			boomarangPresent.merge(values, true)
		elif pType == "void":
			voidPresent.merge(values, true)
		elif pType == "snowman":
			snowmanPresent.merge(values, true)
		elif pType == "coal":
			coalPresent.merge(values, true)

func updateList():
	list.clear()
	list.append(basicPresent0)
	list.append(basicPresent1)
	list.append(basicPresent2)
	list.append(basicPresent3)
	list.append(basicPresent4)
	list.append(basicPresent5)
	list.append(goldPresent)
	list.append(jaffaPresent)
	list.append(rainbowPresent)
	list.append(bouncyPresent)
	list.append(boomarangPresent)
	list.append(voidPresent)
	#list.append(snowmanPresent)
	
func get_random(range_L, range_H):
	return randi_range(range_L, range_H)
	
func newBasic0():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 0,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent0.get("reward_money")[0],basicPresent0.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent0.get("reward_jaffa")[0],basicPresent0.get("reward_jaffa")[1])
	}
	
	return basic
	
func newBasic1():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 1,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent1.get("reward_money")[0],basicPresent1.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent1.get("reward_jaffa")[0],basicPresent1.get("reward_jaffa")[1])
	}
	
	return basic
	
func newBasic2():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 2,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent2.get("reward_money")[0],basicPresent2.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent2.get("reward_jaffa")[0],basicPresent2.get("reward_jaffa")[1])
	}
	
	return basic
	
func newBasic3():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 3,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent3.get("reward_money")[0],basicPresent3.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent3.get("reward_jaffa")[0],basicPresent3.get("reward_jaffa")[1])
	}
	
	return basic
	
func newBasic4():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 4,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent4.get("reward_money")[0],basicPresent4.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent4.get("reward_jaffa")[0],basicPresent4.get("reward_jaffa")[1])
	}
	
	return basic
	
func newBasic5():
		
	var basic = {
		"name" : "Basic Present",
		"texture_index" : 5,
		"mass" : 0,
		"reward_money" : randi_range(basicPresent5.get("reward_money")[0],basicPresent5.get("reward_money")[1]),
		"reward_jaffa" : randi_range(basicPresent5.get("reward_jaffa")[0],basicPresent5.get("reward_jaffa")[1])
	}
	
	return basic
	
func newGold():
		
	var gold = {
		"name" : "Gold Present",
		"texture_index" : 6,
		"mass" : 0,
		"reward_money" : randi_range(goldPresent.get("reward_money")[0],goldPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(goldPresent.get("reward_jaffa")[0],goldPresent.get("reward_jaffa")[1])
	}
	
	return gold

func newJaffa():
		
	var jaffa = {
		"name" : "Jaffa Present",
		"texture_index" : 7,
		"mass" : 0,
		"reward_money" : randi_range(jaffaPresent.get("reward_money")[0],jaffaPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(jaffaPresent.get("reward_jaffa")[0],jaffaPresent.get("reward_jaffa")[1])
	}
	
	return jaffa
	
func newRainbow():
		
	var rainbow = {
		"name" : "Rainbow Present",
		"texture_index" : 8,
		"mass" : 0,
		"reward_money" : randi_range(rainbowPresent.get("reward_money")[0],rainbowPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(rainbowPresent.get("reward_jaffa")[0],rainbowPresent.get("reward_jaffa")[1])
	}
	
	return rainbow
	
func newBouncy(): #TO DO
	var basic = {
		"name" : "Bouncy Present",
		"texture_index" : 9,
		"mass" : 0,
		"reward_money" : randi_range(bouncyPresent.get("reward_money")[0],bouncyPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(bouncyPresent.get("reward_jaffa")[0],bouncyPresent.get("reward_jaffa")[1])
	}
	
	return basic

func newBoomarang(): #TO DO
	var basic = {
		"name" : "Boomarang Present",
		"texture_index" : 10,
		"mass" : 0,
		"reward_money" : randi_range(boomarangPresent.get("reward_money")[0],boomarangPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(boomarangPresent.get("reward_jaffa")[0],boomarangPresent.get("reward_jaffa")[1])
	}
	
	return basic
	
func newVoid(): #TO DO
	var basic = {
		"name" : "Void Present",
		"texture_index" : 11,
		"mass" : 0,
		"reward_money" : randi_range(voidPresent.get("reward_money")[0],voidPresent.get("reward_money")[1]),
		"reward_jaffa" : randi_range(voidPresent.get("reward_jaffa")[0],voidPresent.get("reward_jaffa")[1])
	}
	
	return basic
	
func newSnowman(): #TO DO
	var basic = {
		"name" : "Snowman Head",
		"texture_index" : 12,
		"mass" : 0,
		"reward_money" : 0,
		"reward_jaffa" : 0
	}
	
	return basic
	
func newCoal(): #TO DO
	var basic = {
		"name" : "Chunk of Coal",
		"texture_index" : 13,
		"mass" : 0,
		"reward_money" : 0,
		"reward_jaffa" : 0
	}
	
	return basic
