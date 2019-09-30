extends CanvasLayer

var planetCursor = 0
var isIntroduction = 0
var readyForInput = false
var isSummary = 0
var isTutorial = 0
var curYearSum = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	readyForInput = false
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	if readyForInput:
		if event.is_action_released("ui_left"):
			planetCursor = (planetCursor - 1 + 4) % 4
			setupPlanet()
			get_parent().get_node("Sound/BeepSound/BeepPlayer").play()
		if event.is_action_released("ui_right"):
			planetCursor = (planetCursor + 1) % 4
			setupPlanet()
			get_parent().get_node("Sound/BeepSound/BeepPlayer").play()
		if event.is_action_released("ui_up"):
			$Menu.changeCursor(-1)
			get_parent().get_node("Sound/BeepSound/BeepPlayer").play()
		if event.is_action_released("ui_down"):
			$Menu.changeCursor(1)
			get_parent().get_node("Sound/BeepSound/BeepPlayer").play()
	if event.is_action_released("ui_accept"):
		if $OutputText.isSpeakDialogOpen():
			$OutputText.triggerNextEvent()
		else:
			get_parent().get_node("Sound/BeepSound/BeepPlayer").play()
			var selectedOption = $Menu.acceptCursor()
			if selectedOption == "finish":
				applyChangesandFinishYear()

func getPlanetCursor():
	return planetCursor

func playStart():
	$Menu.visible = false
	$StartingAni.play("Start")

func _on_StartingAni_animation_finished():
	$StartingAni.visible = false
	playIntroduction()

func playIntroduction():
	isIntroduction = 1
	GlobalVariables.createPlanets()
	$Statistics.setStatTitle(5)
	$OutputText.outputText("The year is 2075, due to global warming; the earth is no longer able to support humanity. You have been put in charge of the 'Evacuation Initive' which seeks to relocate humanity to other inner planets in the solar system while terraforming them at the same time.\n \n May you have the universe on your side.")

func setupPlanet():
	$OutputBox.setBoxFrame(planetCursor)
	$Statistics.setStatTitle(planetCursor)
	$Menu.setLowerPlanet(planetCursor)
	$Menu.resetCursor()
	showStats(planetCursor)

func _on_OutputText_textFinished():
	if isIntroduction == 1:
		isTutorial = 1
		$Statistics.setStatTitle(4)
		$OutputText.outputText("Each year you have 5 actions, you spread those across the 4 inner planets. Your goal is to try to build as many colonies as you can before the mass die offs occur on earth. To do this you will need to research, build, terraform and maintain control/happiness. The game will end when the population on earth reaches zero. Use the right/left arrow keys to switch between planets and up/down arrow keys then enter/space to select actions.")
		isIntroduction = 2
	elif isTutorial == 1:
		$Menu.visible = true
		$Statistics.setStatTitle(planetCursor)
		showStats(planetCursor)
		readyForInput = true
		$Menu.setMenuTitle("Actions Remaining : " + str(GlobalVariables.getRemainingMoves()))
		isTutorial = 2
	elif isSummary == 1:
		if GlobalVariables.getPlanet("earth").getPopulation() < 5:
			get_tree().change_scene("res://Game_Assets/EndCard/endGame.tscn")
		isSummary = 0
		$Menu.visible = true
		$Statistics/StatBox/StatsTable.visible = true
		planetCursor = 0
		setupPlanet()
		readyForInput = true
		$Menu.setMenuTitle("Actions Remaining : " + str(GlobalVariables.getRemainingMoves()))

func showStats(planetCursor):
	$Statistics/StatBox/StatsTable/Year/YearLabel.text = str(GlobalVariables.getYear())
	var planetName = GlobalVariables.getPlanetName(planetCursor)
	var planetStats = GlobalVariables.getPlanetStatistics(planetName)
	$Statistics/StatBox/StatsTable/Population/PopLabel.text = "Population : " + str(planetStats["pop"])
	$Statistics/StatBox/StatsTable/HabitatLevel/HabLabel.text = "Habitat Level : " + str(planetStats["habitLvl"])
	if planetName == "earth":
		$Statistics/StatBox/StatsTable/NumColonies/ColLabel.text = "Cities : " + str(planetStats["numColon"])
	else:
		$Statistics/StatBox/StatsTable/NumColonies/ColLabel.text = "Colonies : " + str(planetStats["numColon"])
	$Statistics/StatBox/StatsTable/GovSystem/GovLabel.text = "Government : " + str(planetStats["govSys"])
	$Statistics/StatBox/StatsTable/HappyLvl/HappyLabel.text = "Happiness : " + str(planetStats["happyLvl"])
	if planetName == "earth":
		$Statistics/StatBox/StatsTable/EngineLvl/EnginLabel.text = "Engineering : " + str(GlobalVariables.earthEngineer)
	else:
		$Statistics/StatBox/StatsTable/EngineLvl/EnginLabel.text = "Engineering : " + str(planetStats["engLvl"])

func applyChangesandFinishYear():
	#change all the stats
	var selectedDict = $Menu.getOptionsSelectedDict()
	var earthLossPop = 0
	for planet in selectedDict.keys():
		var planetDict = selectedDict[planet]
		var curPlanetStats = GlobalVariables.getPlanetStatistics(planet)
		var planetObj = GlobalVariables.getPlanet(planet)
		var curYear = GlobalVariables.getYear()
		if planet == "earth":
			var increaseEarthE = false
			if planetDict["research"]:
				GlobalVariables.earthEngineer += 3
				increaseEarthE = true
			if planetDict["build"]:
				GlobalVariables.earthEngineer += 3
				increaseEarthE = true
			if planetDict["terra"]:
				GlobalVariables.earthEngineer += 3
				increaseEarthE = true
			if planetDict["quell"]:
				GlobalVariables.earthEngineer += 3
				increaseEarthE = true
			if planetDict["holiday"]:
				increaseEarthE = true
				GlobalVariables.earthEngineer += 3
			if increaseEarthE:
				if GlobalVariables.earthEngineer < 300:
					GlobalVariables.addToYearSum.append("Thanks to your efforts on earth, we are more easily able to evacuate")
				else:
					GlobalVariables.addToYearSum.append("We are unable to increase evacuation efforts above what is already being accomplished")
					increaseEarthE = 300
			GlobalVariables.makeChange(planet,"govSys",1)
			GlobalVariables.makeChange(planet,"engLvl",0)
			GlobalVariables.makeChange(planet,"numColon",0)
			GlobalVariables.makeChange(planet,"pop",0)
			GlobalVariables.makeChange(planet,"engLvl",-3)
			if( curYear >= 2100 and curYear <= 2125):
				GlobalVariables.addToYearSum.append(str(200000000) + " have died on earth due to ecological collapse")
				earthLossPop += -200000000
			if curYear > 2125:
				GlobalVariables.addToYearSum.append(str(500000000) + " have died on earth due to ecological collapse")
				earthLossPop += -500000000
		else:
			var curGov = curPlanetStats["govNum"]
			var maxPeople = curPlanetStats["numColon"]
			var immegration = 0.0
			var babies = floor(curPlanetStats["pop"]*0.01)
			if curGov < 2:
				#Planet Altering Stats
				if planetDict["research"]:
					var changeEng = 5.0
					if planetDict["holiday"]:
						changeEng = 2.0
					GlobalVariables.makeChange(planet,"engLvl",changeEng)
				
				if planetDict["build"]: #People will only immegrate if colonies are built, otherwise not worth the trip
					var changeColonies = floor(pow(10,((curPlanetStats["engLvl"]+curPlanetStats["happyLvl"])/100)))
					if planetDict["holiday"]:
						changeColonies *= 0.2
					changeColonies = floor(planetObj.fakeChangeColony(changeColonies))*(1 + (GlobalVariables.earthEngineer/50))
					if (changeColonies < 0):
						changeColonies = 0
					var numberOfImmegrants = floor(500000*changeColonies*(1 + (GlobalVariables.earthEngineer/400)))
					if GlobalVariables.getPlanet("earth").getPopulation() < numberOfImmegrants:
						numberOfImmegrants = GlobalVariables.getPlanet("earth").getPopulation()
					immegration += floor(500000*changeColonies)
					GlobalVariables.makeChange(planet,"numColon",changeColonies)
				
				if planetDict["terra"]:
					GlobalVariables.makeChange(planet,"habitLvl",1)
				
				#Social Stats Altering
				curGov = curPlanetStats["govNum"]
				var happyChange = 0.0
				var changeGov = 1
				if curGov == 1:
					changeGov = 1 #Stay authoritarian
					happyChange = -2.0
					if planetDict["quell"]:
						happyChange = -4.0
					else:
						randomize()
						if (randf() < 0.05):
							changeGov = 0
					if planetDict["holiday"]:
						happyChange += 20
				if curGov == 0: 
					changeGov = 0 #Stay Democratic?
					randomize()
					if (randf() < 0.1):
						changeGov = 1
					happyChange = 2.0
					
				if (curPlanetStats["happyLvl"]+happyChange) < 20:
					randomize()
					if (randf() < 0.3):
						changeGov = 2
				GlobalVariables.makeChange(planet,"govSys",changeGov)
				GlobalVariables.makeChange(planet,"happyLvl",happyChange)
				
				earthLossPop += -immegration
				var popChange = immegration + babies
				GlobalVariables.makeChange(planet,"pop",popChange)
				
			elif curGov == 2: #Under anarchy, there is no immegration, and no terraforming
				var changeGov = 2
				randomize()
				var engChange = floor(curPlanetStats["engLvl"]*(0.02)*(randf()))
				var colChange = floor(1.0*sign(randf()))
				var happyChange = floor(curPlanetStats["happyLvl"]*(0.05)*(randf()+0.5))
				if (curPlanetStats["happyLvl"]+happyChange) > 30:
					if (randf() < 0.5):
						changeGov = 1
				
				GlobalVariables.makeChange(planet,"engLvl",engChange)
				GlobalVariables.makeChange(planet,"pop",babies)
				GlobalVariables.makeChange(planet,"numColon",colChange)
				GlobalVariables.makeChange(planet,"happyLvl",happyChange)
				GlobalVariables.makeChange(planet,"govSys",changeGov)
	GlobalVariables.makeChange("earth","pop",earthLossPop)
	#Apply Changes
#	print(GlobalVariables.getYear())
#	print("======================")
#	print(GlobalVariables.getChangeDict())
#	print("======================")
	curYearSum = GlobalVariables.nextYear()
	readyForInput = false
	$Statistics.setStatTitle(6)
	isSummary = 1
	planetCursor = 0
	$Menu.visible = false
	$Statistics/StatBox/StatsTable.visible = false
	$Menu.setMenuTitle("")
	$Menu.resetOptions()
	$Menu.resetCursor()
	get_parent().get_node("Viewport/CelestialBodies").goAround()
	

func _on_CelestialBodies_allPlanetsStopped():
	$OutputText.outputText(curYearSum)
	curYearSum = ""
