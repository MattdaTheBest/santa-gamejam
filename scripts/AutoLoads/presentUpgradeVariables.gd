extends Node

var basicPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var basicPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [7,14],
	"reward_jaffa" : [0,0]
}

var basicPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [10,20],
	"reward_jaffa" : [0,0]
}

var basicPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [14,28],
	"reward_jaffa" : [0,0]
}

var basicPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [25,40],
	"reward_jaffa" : [0,0]
}

var goldPresentLVL1 = {
	"Level" : [1],
	"mass" : 50,
	"reward_money" : [15,20],
	"reward_jaffa" : [0,0]
}

var goldPresentLVL2 = {
	"Level" : [2],
	"mass" : 50,
	"reward_money" : [22,30],
	"reward_jaffa" : [0,0]
}

var goldPresentLVL3 = {
	"Level" : [3],
	"mass" : 50,
	"reward_money" : [31,40],
	"reward_jaffa" : [0,0]
}

var goldPresentLVL4 = {
	"Level" : [4],
	"mass" : 50,
	"reward_money" : [43,50],
	"reward_jaffa" : [0,0]
}

var goldPresentLVL5 = {
	"Level" : [5],
	"mass" : 50,
	"reward_money" : [56,60],
	"reward_jaffa" : [0,0]
}

var jaffaPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [0,0],
	"reward_jaffa" : [2,3]
}

var jaffaPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [5,10],
	"reward_jaffa" : [3,4]
}

var jaffaPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [7,14],
	"reward_jaffa" : [4,5]
}

var jaffaPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [10,20],
	"reward_jaffa" : [5,6]
}

var jaffaPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [14,28],
	"reward_jaffa" : [6,7]
}

var rainbowPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [3,5],
	"reward_jaffa" : [0,0]
}

var rainbowPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [4,6],
	"reward_jaffa" : [0,0]
}

var rainbowPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [5,7],
	"reward_jaffa" : [0,0]
}

var rainbowPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [6,9],
	"reward_jaffa" : [0,0]
}

var rainbowPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [7,11],
	"reward_jaffa" : [0,0]
}

var bouncyPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var bouncyPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [7,14],
	"reward_jaffa" : [0,0]
}

var bouncyPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [10,20],
	"reward_jaffa" : [0,0]
}

var bouncyPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [14,28],
	"reward_jaffa" : [0,0]
}

var bouncyPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [25,40],
	"reward_jaffa" : [0,0]
}

var boomarangPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var boomarangPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [7,14],
	"reward_jaffa" : [0,0]
}

var boomarangPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [10,20],
	"reward_jaffa" : [0,0]
}

var boomarangPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [14,28],
	"reward_jaffa" : [0,0]
}

var boomarangPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [25,40],
	"reward_jaffa" : [0,0]
}

var voidPresentLVL1 = {
	"Level" : [1],
	"reward_money" : [5,10],
	"reward_jaffa" : [0,0]
}

var voidPresentLVL2 = {
	"Level" : [2],
	"reward_money" : [7,14],
	"reward_jaffa" : [0,0]
}

var voidPresentLVL3 = {
	"Level" : [3],
	"reward_money" : [10,20],
	"reward_jaffa" : [0,0]
}

var voidPresentLVL4 = {
	"Level" : [4],
	"reward_money" : [14,28],
	"reward_jaffa" : [0,0]
}

var voidPresentLVL5 = {
	"Level" : [5],
	"reward_money" : [25,40],
	"reward_jaffa" : [0,0]
}

func returnStats(pType, lvl):
	lvl = lvl[0] + 1
	if pType == "basic":
		if lvl == 1:
			return basicPresentLVL1
		if lvl == 2:
			return basicPresentLVL2
		if lvl == 3:
			return basicPresentLVL3
		if lvl == 4:
			return basicPresentLVL4
		if lvl == 5:
			return basicPresentLVL5
	elif pType == "gold":
		if lvl == 1:
			return goldPresentLVL1
		if lvl == 2:
			return goldPresentLVL2
		if lvl == 3:
			return goldPresentLVL3
		if lvl == 4:
			return goldPresentLVL4
		if lvl == 5:
			return goldPresentLVL5
	elif pType == "jaffa":
		if lvl == 1:
			return jaffaPresentLVL1
		if lvl == 2:
			return jaffaPresentLVL2
		if lvl == 3:
			return jaffaPresentLVL3
		if lvl == 4:
			return jaffaPresentLVL4
		if lvl == 5:
			return jaffaPresentLVL5
	elif pType == "rainbow":
		if lvl == 1:
			return rainbowPresentLVL1
		if lvl == 2:
			return rainbowPresentLVL2
		if lvl == 3:
			return rainbowPresentLVL3
		if lvl == 4:
			return rainbowPresentLVL4
		if lvl == 5:
			return rainbowPresentLVL5
	elif pType == "bouncy":
		if lvl == 1:
			return bouncyPresentLVL1
		if lvl == 2:
			return bouncyPresentLVL2
		if lvl == 3:
			return bouncyPresentLVL3
		if lvl == 4:
			return bouncyPresentLVL4
		if lvl == 5:
			return bouncyPresentLVL5
	elif pType == "boomarang":
		if lvl == 1:
			return boomarangPresentLVL1
		if lvl == 2:
			return boomarangPresentLVL2
		if lvl == 3:
			return boomarangPresentLVL3
		if lvl == 4:
			return boomarangPresentLVL4
		if lvl == 5:
			return boomarangPresentLVL5
	elif pType == "void":
		if lvl == 1:
			return voidPresentLVL1
		if lvl == 2:
			return voidPresentLVL2
		if lvl == 3:
			return voidPresentLVL3
		if lvl == 4:
			return voidPresentLVL4
		if lvl == 5:
			return voidPresentLVL5
	
	return null
