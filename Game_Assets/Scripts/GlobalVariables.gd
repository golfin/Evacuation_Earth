extends Node

signal doneWithMoves
var moveCount = 0
var currentYear = 2075
var planetDict = {}
var planetName = ["mercury","venus","earth","mars"]
var addToYearSum = []
var earthEngineer = 0
var musicVol = 0
var soundFXVol = 0

var techTreeDict = {
	"mercury":[
	["solar shield","ice harvester","underground habitats"],
	["genetic enginneered colonists","space elevator","solar collector"],
	["safe astroid redirection","magnetic field generation","surface habitats"],
	["early dyson sphere"]],
	"venus":[
	["balloon habitats","cloud harvester","weather shield"],
	["improved weather shield","balloon cities","temporary surface harvester"],
	["space mirror","genetic enginneered microbes","permanent surface harvester"],
	["space elevator"]],
	"earth":[
	["immigration station"],
	["space archieve"],
	["moon colony"],
	["space elevator"]],
	"mars":[
	["ice harvester","underground habitats","genetic enginneered microbes"],
	["genetic enginneered colonists","surface habitats","space elevator"],
	["safe astroid redirection","magnetic field generation","surface habitats"],
	["early core reignition"]]
}

var statNameArr = ["pop","habitLvl","numColon","govSys","happyLvl","engLvl"]
var yearChange = {
"mercury":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
"venus":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
"earth":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
"mars":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0}}



class techTree:
	var _level
	var _techTree
	func _init(initLevel,techAvailible):
		self._level = initLevel
		self._techTree = techAvailible
	
	func getTechLevel():
		return self._level
	
	func setTechTree(tree):
		self._techTree = tree
	
	func setTechLevel(level):
		self._level = level
	
	func whatTechAvailible():
		var techArr = []
		for i in range(self._level):
			for tech in self._techTree[i]:
				techArr.append(tech)
		return techArr
	
	func getNewTech():
		return self._techTree[self._level]
	
	func isTechAvailible(tech):
		return whatTechAvailible().has(tech)

class planet:
	var _name
	var _ownTech
	var _population
	var _habitLevel
	var _numColony
	var _govSystem
	var _happinessLevel
	var _engLevel
	
	func _init(name,initTechLevel,
	initTechTree,initPopulation,initHabitLevel,
	initNumColony,initGovSys,initHappyLevel,
	initEnginLevel):
		self._name = name
		self._ownTech = techTree.new(initTechLevel,initTechTree)
		self._population = initPopulation
		self._habitLevel = initHabitLevel
		self._numColony = initNumColony
		self._govSystem = initGovSys
		self._happinessLevel = initHappyLevel
		self._engLevel = initEnginLevel
	
	func getName():
		return self._name
	
	func refreshTechLevel():
		self._ownTech.setTechLevel(floor(self._engLevel/33))
		return self._ownTech.getTechLevel()
	
	func getTechLevel():
		return self._ownTech.getTechLevel()
	
	func whatAvailibleTech():
		return self._ownTech.whatTechAvailible()
	
	func isTechAvailible(tech):
		return self._ownTech.isTechAvailible(tech)
	
	func getNewTech():
		return self._ownTech.getNewTech()
	
	func changePopulation(number):
		self._population += number
		if self._population < 0:
			self._population = 0
		if ((self._population) > (self._numColony*1000000)):
			var deadPeople = (self._population - self._numColony*1000000)
			GlobalVariables.addToYearSum.append(self._name + " reached capacity! " + str(deadPeople) + " were lost")
			self._population = self._numColony*1000000
		return self._population
	
	func fakeChangePopulation(number):
		var newPop = self._population + number
		if newPop < 0:
			newPop = 0
		
		if ((newPop) > (self._numColony*1000000)):
			newPop = self._numColony*1000000
		return (newPop - self._population)
	
	func getPopulation():
		return self._population
	
	func changeHabitLevel(amount):
		var oldHabit = self._habitLevel
		self._habitLevel += amount
		if self._habitLevel < 0:
			self._habitLevel = 0
		if self._habitLevel >= ceil(self._engLevel/33):
			self._habitLevel = ceil(self._engLevel/33)
		if self._habitLevel > 3:
			self._habitLevel = 3
		if self._habitLevel != 3:
			if oldHabit != self._habitLevel:
				if self._name != "earth":
					GlobalVariables.addToYearSum.append(self._name + " was successfully made more habitable!")
				else:
					if oldHabit > self._habitLevel:
						GlobalVariables.addToYearSum.append(self._name + " has suffered an ecological die off")
			else:
				if amount != 0:
					if self._name != "earth":
						GlobalVariables.addToYearSum.append(self._name + " was unable to be made more habitable, our technology just isn't there.")
		else:
			if amount != 0:
				GlobalVariables.addToYearSum.append(self._name + " is fully terraformed.")
		return self._habitLevel
	
	func fakeChangeHabitLevel(amount):
		var newHL = self._habitLevel + amount
		if newHL < 0:
			newHL = 0
		if newHL >= ceil(self._engLevel/33):
			newHL = ceil(self._engLevel/33)
		if newHL > 3:
			newHL = 3
		return newHL
	
	func getHabitLevel():
		return self._habitLevel
	
	func changeColonyNum(amount):
		var oldNumColony = self._numColony
		self._numColony += amount
		if self._name == "earth":
			return self._numColony
		
		if self._habitLevel == 0:
			if self._numColony > 1:
				GlobalVariables.addToYearSum.append(self._name + " was unable to support more than 1 colony")
				self._numColony = 1
		elif self._habitLevel == 1:
			if (self._numColony) > 100:
				GlobalVariables.addToYearSum.append(self._name + " was unable to support more than 100 colonies")
				self._numColony = 100
		elif self._habitLevel == 2:
			if (self._numColony > 1000):
				GlobalVariables.addToYearSum.append(self._name + " was unable to support more than 1000 colonies")
				self._numColony = 1000
		if self._numColony != oldNumColony:
			if oldNumColony > self._numColony:
				GlobalVariables.addToYearSum.append(self._name + " had " + str(oldNumColony - self._numColony) + " colonies destroyed")
			else:
				GlobalVariables.addToYearSum.append(self._name + " had " + str(self._numColony - oldNumColony) + " colonies built")
		return self._numColony
	
	func fakeChangeColony(amount):
		var newAmount = self._numColony + amount
		if self._name == "earth":
			return amount
		if self._habitLevel == 0:
			if newAmount > 0:
				newAmount = 1
		elif self._habitLevel == 1:
			if (newAmount) > 10:
				newAmount = 10
		elif self._habitLevel == 2:
			if (newAmount > 1000):
				newAmount = 1000
		return (newAmount - self._numColony)
	
	func getColonyNum():
		return self._numColony
	
	func changeSystemGov(amount):
		var oldSys = self._govSystem
		if amount < 0:
			self._govSystem = 2
			if oldSys != self._govSystem:
				GlobalVariables.addToYearSum.append(self._name + " has had enough and has fallen under anarchy")
		else:
			self._govSystem = (amount) % 2
			if self._govSystem == 0:
				if oldSys != self._govSystem:
					GlobalVariables.addToYearSum.append(self._name + " has established itself as a democracy, you will not be able to control the social aspects of its society")
			if self._govSystem == 1:
				if oldSys != self._govSystem:
					GlobalVariables.addToYearSum.append(self._name + " has given itself up to your rule.")
		return self._govSystem
	
	func getGovName():
		if self._govSystem == 0:
			return "Democratic"
		if self._govSystem == 1:
			return "Authoritarian"
		if self._govSystem == 2:
			return "Anarchy"
	
	func anarchyTime():
		self._govSystem = 2
		return self._govSystem
	
	func getSystemGov():
		return self._govSystem
	
	func changeHappinessLevel(amount):
		self._happinessLevel += amount
		if self._happinessLevel < 0:
			self._happinessLevel = 0
		if self._happinessLevel > 100:
			self._happinessLevel = 100
		return self._happinessLevel
	
	func getHappinessLevel():
		return self._happinessLevel
	
	func changeEngineeringLevel(amount):
		var oldEngLevel = self._engLevel
		self._engLevel += amount
		if self._engLevel < 0:
			self._engLevel = 0
		if self._engLevel > 100:
			self._engLevel = 100
		if self._name != 'earth':
			if oldEngLevel != self._engLevel:
				if oldEngLevel < self._engLevel:
					GlobalVariables.addToYearSum.append(self._name + " has advanced its ability to make technology")
				else:
					GlobalVariables.addToYearSum.append(self._name + " has regressed in its technological ability")
		self._ownTech.setTechLevel(floor(self._engLevel/33))
		return self._engLevel
	
	func getEngineeringLevel():
		return self._engLevel

#	func _init(name,initTechLevel, initTechTree,
#	initPopulation,initHabitLevel,
#	initNumColony,initGovSys,initHappyLevel,
#	initEnginLevel)


func createPlanets():
	for name in planetName:
		if name == "earth":
			var planetObj = planet.new(name,0,techTreeDict[name],10000000000,3,11000,1,50,100)
			planetObj.refreshTechLevel()
			planetDict[name] = planetObj
		else:
			var planetObj = planet.new(name,0,techTreeDict[name],10,0,1,1,100,10)
			planetObj.refreshTechLevel()
			planetDict[name] = planetObj
	pass

func getPlanet(name):
	return planetDict[name]

func getPlanetNames():
	return planetName

func getPlanetName(cursor):
	return planetName[cursor]

func getPlanetStatistics(name):
	var statDict = {}
	statDict["pop"] = planetDict[name].getPopulation()
	statDict["habitLvl"] = planetDict[name].getHabitLevel()
	statDict["numColon"] = planetDict[name].getColonyNum()
	statDict["govSys"] = planetDict[name].getGovName()
	statDict["happyLvl"] = planetDict[name].getHappinessLevel()
	statDict["engLvl"] = planetDict[name].getEngineeringLevel()
	statDict["govNum"] = planetDict[name].getSystemGov()
	return statDict

func getStatNameArr():
	return statNameArr

func resetYearChange():
	yearChange = {
	"mercury":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
	"venus":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
	"earth":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0},
	"mars":{"pop":0,"habitLvl":0,"numColon":0,"govSys":0,"happyLvl":0,"engLvl":0}}

func makeChange(name,stat,amount):
	yearChange[name][stat] = amount

func getChange(name,stat):
	return yearChange[name][stat]

var yearSummary = ""

func getChangeDict():
	return yearChange

func getYearSummary():
	return yearSummary

func getRemainingMoves():
	return 5 - moveCount

func getUsedMoves():
	return moveCount

func useMove():
	moveCount = moveCount + 1
	if moveCount >= 5:
		moveCount = 5
		emit_signal("doneWithMoves")
	return moveCount

func nextYear():
	yearSummary = "Summary of " + str(getYear()) + "\n"
	yearSummary += " =================== \n "
	currentYear += 1
	var changePopDict = {}
	for name in planetName:
		changePopDict[name] = getPlanet(name).fakeChangePopulation(getChange(name,"pop"))
		getPlanet(name).changeHabitLevel(getChange(name,"habitLvl"))
		getPlanet(name).changeColonyNum(getChange(name,"numColon"))
		getPlanet(name).changePopulation(getChange(name,"pop"))
		getPlanet(name).changeSystemGov(getChange(name,"govSys"))
		getPlanet(name).changeHappinessLevel(getChange(name,"happyLvl"))
		getPlanet(name).changeEngineeringLevel(getChange(name,"engLvl"))
	
	yearSummary += " Population Change\n"
	for name in planetName:
		yearSummary += " " + name + " : " + str(changePopDict[name]) + "\n "
	yearSummary += " ------------------- \n "
	for line in addToYearSum:
		yearSummary += " - " + line + " \n "
	yearSummary += "-- End of Summary --"
	moveCount = 0
	resetYearChange()
	addToYearSum = []
	return yearSummary

func getYear():
	return currentYear