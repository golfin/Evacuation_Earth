extends VBoxContainer

var cursor = 0
var soundFXLevel = 9
var musicFXLevel = 9
var volLevels = [-0.02, -0.05, -0.13, -0.32, -0.8, -2.0, -5.0, -12.7, -31.8, -80]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	setCursorSprite()
	pass #Replace with function body.

func _input(event):
	if (event.is_action_released("ui_up")):
		cursor = (cursor + 3) % 4
		get_parent().get_parent().get_node("BeepSound/BeepPlayer").play()
		setCursorSprite()
	if event.is_action_released("ui_down"):
		cursor = (cursor + 1) % 4
		get_parent().get_parent().get_node("BeepSound/BeepPlayer").play()
		setCursorSprite()
	if event.is_action_released("ui_left"):
		if cursor == 1:
			musicFXLevel = (musicFXLevel + 9) % 10
			$MusicVol/LabelContainer/MusicVol.text = "Music : " + str(musicFXLevel + 1)
			GlobalVariables.musicVol = volLevels[9 - musicFXLevel]
			get_parent().get_parent().get_node("BackgroundMusic/AudioStreamPlayer").volume_db = volLevels[9 - musicFXLevel]
		if cursor == 2:
			soundFXLevel = (soundFXLevel + 9) % 10
			$SoundFXVol/LabelContainer/FXVol.text = "Sound FX : " + str(soundFXLevel + 1)
			GlobalVariables.soundFXVol = volLevels[9 - soundFXLevel]
			get_parent().get_parent().get_node("BeepSound/BeepPlayer").volume_db = volLevels[9 - soundFXLevel]
	if event.is_action_released("ui_right"):
		if cursor == 1:
			musicFXLevel = (musicFXLevel + 1) % 10
			$MusicVol/LabelContainer/MusicVol.text = "Music : " + str(musicFXLevel + 1)
			GlobalVariables.musicVol = volLevels[9 - musicFXLevel]
			get_parent().get_parent().get_node("BackgroundMusic/AudioStreamPlayer").volume_db = volLevels[9 - musicFXLevel]
		if cursor == 2:
			soundFXLevel = (soundFXLevel + 1) % 10
			$SoundFXVol/LabelContainer/FXVol.text = "Sound FX : " + str(soundFXLevel + 1)
			GlobalVariables.soundFXVol = volLevels[9 - soundFXLevel]
			get_parent().get_parent().get_node("BeepSound/BeepPlayer").volume_db = volLevels[9 - soundFXLevel]
	if event.is_action_released("ui_accept"):
		if cursor == 0:
			get_parent().get_parent().get_node("MainMenuCamera").moveCamera(0,-480)
			get_parent().get_parent().get_node("BackgroundMusic").fadeMusic()
			get_parent().get_parent().get_node("CanvasModulate").fadeToBlack()
		if cursor == 4:
			get_tree().quit()
		



func setCursorSprite():
	if cursor == 0:
		$Play/SpriteContainer/PlayArrow.visible = true
		$MusicVol/SpriteContainer/MusicArrow.visible = false
		$SoundFXVol/SpriteContainer/FXArrow.visible = false
		$Quit/SpriteContainer/QuitArrow.visible = false
	if cursor == 1:
		$Play/SpriteContainer/PlayArrow.visible = false
		$MusicVol/SpriteContainer/MusicArrow.visible = true
		$SoundFXVol/SpriteContainer/FXArrow.visible = false
		$Quit/SpriteContainer/QuitArrow.visible = false
	if cursor == 2:
		$Play/SpriteContainer/PlayArrow.visible = false
		$MusicVol/SpriteContainer/MusicArrow.visible = false
		$SoundFXVol/SpriteContainer/FXArrow.visible = true
		$Quit/SpriteContainer/QuitArrow.visible = false
	if cursor == 3:
		$Play/SpriteContainer/PlayArrow.visible = false
		$MusicVol/SpriteContainer/MusicArrow.visible = false
		$SoundFXVol/SpriteContainer/FXArrow.visible = false
		$Quit/SpriteContainer/QuitArrow.visible = true

func _on_CanvasModulate_doneWithFade():
	get_tree().change_scene("res://Game_Assets/SolarSystem/SolarSystem.tscn")
