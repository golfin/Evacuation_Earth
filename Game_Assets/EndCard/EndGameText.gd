extends MarginContainer

#func getPlanetStatistics(name):
#	var statDict = {}
#	statDict["pop"] = planetDict[name].getPopulation()
#	statDict["habitLvl"] = planetDict[name].getHabitLevel()
#	statDict["numColon"] = planetDict[name].getColonyNum()
#	statDict["govSys"] = planetDict[name].getGovName()
#	statDict["happyLvl"] = planetDict[name].getHappinessLevel()
#	statDict["engLvl"] = planetDict[name].getEngineeringLevel()
#	statDict["govNum"] = planetDict[name].getSystemGov()
#	return statDict

func createEndText():
	var endText = "The initive ended in " +str(GlobalVariables.getYear())+", \n as there is no one left to evacuate. \n\n"
	var totalPopulation = 0
	var totalEnginneering = 0
	var totalGovernment = 0
	var totalHabitability = 0
	var totalHappiness = 0
	for planetName in GlobalVariables.getPlanetNames():
		if planetName == "earth":
			continue
		var statDict = GlobalVariables.getPlanetStatistics(planetName)
		totalPopulation += statDict["pop"]
		totalEnginneering += statDict["engLvl"]
		if statDict["govNum"] == 2:
			totalGovernment += -1
		else:
			totalGovernment += statDict["govNum"]
		totalHabitability += statDict["habitLvl"]
		totalHappiness += statDict["happyLvl"]
	if totalPopulation >= 10000000:
		endText += "The evacuation has been considered a complete success,\n humanity shall prosper.\n"
	elif 10000000 > totalPopulation and totalPopulation >= 1000000:
		endText += "Humanity will easily survive, thanks to your efforts. \n"
	elif 1000000 > totalPopulation and totalPopulation >= 10000:
		endText += "Humanity will not die out, thanks to your efforts. \n"
	elif 10000 > totalPopulation:
		endText += "Humanity will struggle to maintain population, \nthe evacuation was a failure. \n"
	
	if (totalEnginneering >= 250):
		endText += "Humanity will continue to become a type 2 civilization;\n opening up the stars \n"
	elif (250 > totalEnginneering and totalEnginneering >= 150):
		endText +=  "Humanity has gained the ability to terraform quickly\n and easily; opening up the rest of the solar system \n"
	elif  (150 > totalEnginneering and totalEnginneering >= 50):
		endText += "Humanity will prosper in the colonies \n that have been created \n"
	elif (50 > totalEnginneering):
		endText += "Humanity will struggle to survive outside of earth \n"
	
	if (totalGovernment >= 3):
		endText += "Your government will reign for many years \n"
	elif (3 > totalGovernment) and (totalGovernment > 0):
		endText += "Humanity will remember your governing in times of need \n"
	elif (totalGovernment <= 0):
		endText += "Humanity will forget you and no longer needs you \n"
	
	if (totalHabitability >= 8):
		endText += "The inner planets have become a \n staging ground for humanity \n"
	elif (8 > totalHabitability) and (totalHabitability >= 4):
		endText += "The inner planets have become a\n home for those who live there \n"
	elif (totalHabitability < 4):
		endText += "The inner planets shall be a \nplace to survive \n"
	
	if (totalHappiness >= 250):
		endText += "Humanity is happy \n"
	elif (totalHappiness < 250) and ( 150 <= totalHappiness):
		endText += "Humanity is content \n"
	elif (totalHappiness < 150):
		endText += "Humanity is stressed \n"
	
	endText += "\n Created by Golfin \n Music : \n Gravity's Kiss - Daniel Robert Lahey (CC BY-NC-ND 3.0) \n 7.83 Hz - Jack Hertz (CC BY-NC-ND 3.0) \n Beep sound effect by qubodup (CC0) \n Silkscreen font by Jason Kottke \n (Kottke Silkscreen License v1.00)"
	endText += "\n\n Thank you for playing, press any key to exit"
	$TextOutput/EndGameOutput.text = endText
	pass
