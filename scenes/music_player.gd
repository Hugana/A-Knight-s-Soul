extends AudioStreamPlayer2D

# Playlist of music tracks
var playlist = [
	"res://assets/music/speculum.mp3",
	"res://assets/music/reflector.mp3",
	"res://assets/music/polished metal.mp3",
	"res://assets/music/Mirrors.mp3",
	"res://assets/music/glass.mp3"
]

# Current track index
var current_index = 0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Play the first track
	play_current_track()
	# Connect the "finished" signal to the `_on_track_finished` method
	self.finished.connect(_on_track_finished)

# Plays the current track from the playlist
func play_current_track():
	if playlist.size() == 0:  # Correct check for an empty playlist
		print("Playlist is empty! No music to play.")
		return
	# Load and play the current track
	stream = load(playlist[current_index])
	if stream:
		play()
		print("Now playing: %s" % playlist[current_index])
	else:
		print("Failed to load track: %s" % playlist[current_index])

# Handles when the current track finishes
func _on_track_finished():
	# Move to the next track in the playlist
	current_index += 1
	if current_index >= playlist.size():
		current_index = 0  # Loop back to the first track
	# Play the next track
	play_current_track()
