extends Node


func setPlanet(planetName):
	var curTechLevel = GlobalVariables.getPlanet(planetName).getTechLevel()
	var planetInd = GlobalVariables.getPlanetNames().bsearch(planetName)
	$Planet.frame = planetInd*4 + curTechLevel