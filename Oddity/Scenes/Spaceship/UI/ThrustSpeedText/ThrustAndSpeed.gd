extends Control

var speeda : float
var throttlea : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer/HBoxContainer/RichTextLabel.text = "speed: " + str(speeda) + "\nThrottle: " + str(throttlea)


func _on_fighter_gen_7_speed_signal(speed):
	speeda = speed


func _on_user_control_throttle_signal(throttle):
	throttlea = throttle
