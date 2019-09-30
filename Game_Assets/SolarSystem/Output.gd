extends MarginContainer

var optionCursor = 0

var optionNames = ["research","build","terra","quell","holiday","finish"]

var planetOptions = [
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]]

var optionsSelected = [
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]]

var rowTextNode = []
var arrowNodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rowTextNode = [$ListContainer/MenuArea/MenuList/ResearchRow/textCon/ResearchLabel,
	$ListContainer/MenuArea/MenuList/BuildRow/BuildText/BuildLabel,
	$ListContainer/MenuArea/MenuList/TerraRow/TerraText/TerraLabel,
	$ListContainer/MenuArea/MenuList/QuellRow/QuellText/QuellLabel,
	$ListContainer/MenuArea/MenuList/HolidayRow/HolidayText/HolidayLabel,
	$ListContainer/MenuArea/MenuList/FinishRow/FinishText/FinishLabel]
	
	arrowNodes = [$ListContainer/MenuArea/MenuList/ResearchRow/arrowCon/arrowPic,
	$ListContainer/MenuArea/MenuList/BuildRow/BuildArrow/arrowPic,
	$ListContainer/MenuArea/MenuList/TerraRow/TerraArrow/arrowPic,
	$ListContainer/MenuArea/MenuList/QuellRow/QuellArrow/arrowPic,
	$ListContainer/MenuArea/MenuList/HolidayRow/HolidayArrow/arrowPic,
	$ListContainer/MenuArea/MenuList/FinishRow/FinishArrow/arrowPic]
	greyOutOptions()
	pass # Replace with function body.

func resetOptions():
	planetOptions = [
	[0,0,0,0,0,0],
	[0,0,0,0,0,0],
	[0,0,0,0,0,0],
	[0,0,0,0,0,0]]
	
	var planetInd = 0
	for planetN in GlobalVariables.getPlanetNames():
		var govSys = GlobalVariables.getPlanet(planetN).getSystemGov()
		if govSys == 0:
			planetOptions[planetInd] = [0,0,0,1,1,0]
		if govSys == 2:
			planetOptions[planetInd] = [1,1,1,1,1,0]
		planetInd += 1
	
	optionsSelected = [
	[0,0,0,0,0,0],
	[0,0,0,0,0,0],
	[0,0,0,0,0,0],
	[0,0,0,0,0,0]]

func disableOption(planet,option):
	var planetNames = GlobalVariables.getPlanetNames()
	var planetInd = 0
	for planetName in planetNames:
		var optionInd = 0
		for optionName in optionNames:
			if (planetName == planet) and (optionName == option):
				planetOptions[planetInd][optionInd] = 1
			optionInd += 1
		planetInd += 1

func setMenuTitle(title):
	$ListContainer/MenuTitle/MenuTitleText.text = title

func setLowerPlanet(planetCursor):
	var planetName = GlobalVariables.getPlanetName(planetCursor)
	var habitLvl = GlobalVariables.getPlanet(planetName).getHabitLevel()
	$ListContainer/LowerPanel/Planet.frame = planetCursor*4 + habitLvl

func greyOutOptions():
	var planetCursor = get_parent().getPlanetCursor()
	var optionArr = planetOptions[planetCursor]
	var optionInd = 0
	for optionBool in optionArr:
		if optionBool == 1:
			rowTextNode[optionInd].add_color_override("font_color",Color.gray)
		else:
			rowTextNode[optionInd].add_color_override("font_color",Color.white)
		optionInd += 1
	changeCursor(0)
	

func resetCursor():
	optionCursor = 0
	greyOutOptions()

func changeCursor(amount):
	optionCursor = (optionCursor + amount + 6) % 6
	var planetCursor = get_parent().getPlanetCursor()
	var optionArr = planetOptions[planetCursor]
	var rowInd = 0
	while rowInd < 6:
		var arrow = arrowNodes[rowInd]
		if optionCursor == rowInd:
			if (optionArr[rowInd] == 0):
				arrow.visible = true
				rowInd += 1
			else:
				if 0 <= amount:
					optionCursor =  (optionCursor + 1) % 6
				else:
					optionCursor =  (optionCursor + 5) % 6
				rowInd = 0
				
		else:
			arrow.visible = false
			rowInd += 1
		
	pass

func getOptionsSelected():
	return optionsSelected

func getOptionsSelectedDict():
	var returnedDict = {}
	var planetNames = GlobalVariables.getPlanetNames()
	var planetInd = 0
	for planetName in planetNames:
		returnedDict[planetName] = {}
		var optionInd = 0
		for optionSelectBool in optionsSelected[planetInd]:
			if optionSelectBool == 1:
				returnedDict[planetName][optionNames[optionInd]] = true
			else:
				returnedDict[planetName][optionNames[optionInd]] = false
			optionInd += 1
		planetInd += 1
	return returnedDict

func acceptCursor():
	var planetCursor = get_parent().getPlanetCursor()
	planetOptions[planetCursor][optionCursor] = 1
	optionsSelected[planetCursor][optionCursor] = 1
	GlobalVariables.useMove()
	var usedMoves = GlobalVariables.getUsedMoves()
	var remainingMoves = GlobalVariables.getRemainingMoves()
	get_parent().get_node("Menu").setMenuTitle("Actions Remaining : " + str(remainingMoves))
	var returnedOption = optionNames[optionCursor]
	if returnedOption == "finish":
		return returnedOption
	if remainingMoves <= 0:
		remainingMoves = 0 
		planetOptions = [[1,1,1,1,1,0],[1,1,1,1,1,0],[1,1,1,1,1,0],[1,1,1,1,1,0]]
	greyOutOptions()
	return returnedOption