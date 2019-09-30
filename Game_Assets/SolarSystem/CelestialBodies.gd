extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal allPlanetsStopped
var angularSpeedArr = [180,160,140,120]
var angleArr = [0,0,0,0]
var radiusArr = [65,105,145,185]
var goingAround = false
var planetSpriteArr = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	planetSpriteArr[0] = get_node("Mercury/MercurySprite")
	planetSpriteArr[1] = get_node("Venus/VenusSprite")
	planetSpriteArr[2] = get_node("Earth/EarthSprite")
	planetSpriteArr[3] = get_node("Mars/MarsSprite")
	pass # Replace with function body.

func goAround():
	angleArr = [0,0,0,0]
	goingAround = true

func _physics_process(delta):
	if goingAround:
		var allStopped = true
		for angle in angleArr:
			if angle < 359:
				allStopped = false
		if allStopped:
			var earthHabitLvl = GlobalVariables.getPlanet("earth").getHabitLevel()
			$Earth/EarthSprite.frame = (4 - earthHabitLvl)
			goingAround = false
			emit_signal("allPlanetsStopped")
		else:
			var planetInd = 0
			for angle in angleArr:
				var planetSprite = planetSpriteArr[planetInd]
				if (angle < 359):
					angleArr[planetInd] = angleArr[planetInd] + angularSpeedArr[planetInd]*delta
					planetSprite.global_position.x = radiusArr[planetInd]*cos(angleArr[planetInd]*(3.141592/180)) + 45
					planetSprite.global_position.y = radiusArr[planetInd]*sin(angleArr[planetInd]*(3.141592/180)) + 125
				else:
					angleArr[planetInd] = 360
					planetSprite.global_position.x = radiusArr[planetInd] + 45
					planetSprite.global_position.y = 125
				planetInd += 1

func isGoingAround():
	return goingAround