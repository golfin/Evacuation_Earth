extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/StartingAni.visible = true
	$UI.playStart()
	$Sound/BeepSound/BeepPlayer.volume_db = GlobalVariables.soundFXVol
	$Sound/BackgroundMusic.fadeInMusic()
	pass # Replace with function body.

