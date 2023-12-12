extends Node3D

var last_fuel : float = 0.0
var current_fuel : float
var fuel_usage : float

@export
var fuel_tank : Node3D

### UI stuff is very w.i.p 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_fuel_usage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_fuel_bar()
	set_current_fuel()
	
func set_fuel_bar():
	$SubViewport/FuelBar2d/FuelBar.value = (fuel_tank.current_fuel_capacity * 100) / fuel_tank.total_fuel_capacity
	
func set_current_fuel():
	$"Current Fuel".text = str(round(fuel_tank.current_fuel_capacity)) + " l"
	
func set_fuel_usage():
	current_fuel = fuel_tank.current_fuel_capacity
	
	fuel_usage = round(last_fuel - current_fuel)
	calculate_range(fuel_usage)
	
	$SubViewport/FuelBar2d/FuelUsage.value = fuel_usage
	$"Fuel Usage".text = str(fuel_usage) + " l / s"

	last_fuel = current_fuel
	
	$Timer.start()

func calculate_range(fuel_usage : float):
	# Calculate the total flight time in seconds
	var total_time_seconds = fuel_tank.current_fuel_capacity / fuel_usage

	# Convert seconds to hours and minutes
	var hours = int(total_time_seconds / 3600)
	var minutes = int(fmod(total_time_seconds, 3600) / 60)

	$"Range Estimate".text = str(hours) + " h " + str(minutes) + " min"

func _on_timer_timeout():
	set_fuel_usage()
