extends Node

onready var tween_out = get_node("Tween")

export var transition_duration = 4.00
export var transition_type = 1 # TRANS_SINE


func fadeInMusic():
	var streamPlayer = $MusicPlayer
	fade_in(streamPlayer)

func fade_in(stream_player):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", -80, GlobalVariables.musicVol, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    # when the tween ends, the music will be stopped


