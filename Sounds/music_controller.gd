extends Node

@onready var background_player := $BackgroundMusic
@onready var effects_player := $EffectsPlayer

const LOWER_VOLUME := 10

var _last_played: AudioStream = null

func play_music(stream: AudioStream):
	if stream == _last_played:
		return
	
	background_player.stream = stream
	background_player.play()

func play_effect(stream: AudioStream):
	background_player.volume_db -= LOWER_VOLUME
	effects_player.stream = stream
	effects_player.play()
	await effects_player.finished
	background_player.volume_db += LOWER_VOLUME
