extends AudioStreamPlayer

var current_track: AudioStream
var reverb: AudioEffectReverb
var lowpass_filter: AudioEffectLowPassFilter

const music_dic: Dictionary = {
	"Sunset Juice" = preload("res://Assets/Audio/Music/Sunset Juice.mp3"),
}

func _ready() -> void:
	reverb = AudioServer.get_bus_effect(1, 0)
	lowpass_filter = AudioServer.get_bus_effect(1, 1)
	current_track = random_track()
	stream = current_track
	play()

func _on_finished() -> void:
	current_track = random_track(true)
	stream = current_track
	play()

func random_track(avoid_current_track: bool = false) -> AudioStream:
	if avoid_current_track:
		var keys = music_dic.keys()
		var random_key = keys.pick_random
		if random_key == music_dic[current_track]:
			return random_track(avoid_current_track)
		else:
			return music_dic[random_key]
	else:
		var keys = music_dic.keys()
		var random_key = keys.pick_random()
		return music_dic[random_key]

func set_reverb_wet(target_value: float, target_dry_value: float = reverb.dry, transition_time: float = 0) -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(reverb, "wet", target_value, transition_time)
	tween.tween_property(reverb, "dry", target_dry_value, transition_time)
	if target_value > 0.0:
		AudioServer.set_bus_volume_db(1, -10.0)
	else:
		AudioServer.set_bus_volume_db(1, -5.0)

func set_lowpass_freq(target_freq: float, transition_time: float = 0) -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(lowpass_filter, "cutoff_hz", target_freq, transition_time)
