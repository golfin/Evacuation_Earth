extends Node

onready var tween_out = get_node("Tween")

export var transition_duration = 4.00
export var transition_type = 1 # TRANS_SINE


func fadeMusic():
	var streamPlayer = $AudioStreamPlayer
	fade_out(streamPlayer)

func fade_out(stream_player):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", GlobalVariables.musicVol, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    # when the tween ends, the music will be stopped

func _on_Tween_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
    object.stop()
