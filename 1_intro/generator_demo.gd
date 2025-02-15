extends Node

#see https://docs.godotengine.org/en/3.6/classes/class_audiostreamgenerator.html

var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 140.0
var phase = 0.5

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().


func _process(_delta):
	pass


func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * cos(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1

func _fill_buffer2():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2(1.0,1.0) * sin(phase * (PI * 2.0))) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	$Player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = $Player.get_stream_playback()
	_fill_buffer2() # Prefill, do before play() to avoid delay.
	$Player.play()
	yield(get_tree().create_timer(0.2), "timeout")
	$Player.stop()

