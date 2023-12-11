extends Node3D

var total_power_output : float
var current_power_output : float

# Called when the node enters the scene tree for the first time.
func _ready():
	total_power_output = count_total_power_output()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_power_output = count_current_power_output()

func count_total_power_output() -> float:
	var power : float
	
	for power_plant in get_children():
		power += power_plant.total_power_output
	
	return power

func count_current_power_output() -> float:
	var power : float
	
	for power_plant in get_children():
		power += power_plant.current_power_output
	
	return power
	
