extends Node3D

var total_power_output : float
var current_power_output : float
var current_power_plant_fuel_usage : float

var total_fuel_capacity : float
var current_fuel_capacity : float

var total_component_cooling_output : float
var current_component_cooling_output : float

var total_radiator_cooling_output : float
var current_radiator_cooling_output : float

var total_shield_output : float
var current_shield_output : float

@export
var rigid_body : RigidBody3D

var dry_weight : float

# Called when the node enters the scene tree for the first time.
func _ready():
	dry_weight = rigid_body.mass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_current_values()
	set_total_values()
	
	$"Fuel Tanks".use_fuel(current_power_plant_fuel_usage)

	rigid_body.mass = dry_weight + current_fuel_capacity * 0.00013
	
	#print_status()

func set_current_values():
	current_power_output = $"Power Plants".current_power_output
	current_fuel_capacity = $"Fuel Tanks".current_fuel_capacity
	current_component_cooling_output = $Coolers.current_cooling_output
	current_radiator_cooling_output = $Radiators.current_cooling_output
	current_shield_output = $"Shield Generators".current_shield_output
	
	current_power_plant_fuel_usage = $"Power Plants".current_fuel_usage

func set_total_values():
	total_power_output = $"Power Plants".total_power_output
	total_fuel_capacity = $"Fuel Tanks".total_fuel_capacity
	total_component_cooling_output = $Coolers.total_cooling_output
	total_radiator_cooling_output = $Radiators.total_cooling_output
	total_shield_output = $"Shield Generators".total_shield_output

func print_status():
	print("Power Output Status:")
	print("  Total Power Output: %f" % total_power_output)
	print("  Current Power Output: %f" % current_power_output)

	print("\nFuel Capacity Status:")
	print("  Total Fuel Capacity: %f" % total_fuel_capacity)
	print("  Current Fuel Capacity: %f" % current_fuel_capacity)

	print("\nComponent Cooling Output Status:")
	print("  Total Component Cooling Output: %f" % total_component_cooling_output)
	print("  Current Component Cooling Output: %f" % current_component_cooling_output)

	print("\nRadiator Cooling Output Status:")
	print("  Total Radiator Cooling Output: %f" % total_radiator_cooling_output)
	print("  Current Radiator Cooling Output: %f" % current_radiator_cooling_output)

	print("\nShield Output Status:")
	print("  Total Shield Output: %f" % total_shield_output)
	print("  Current Shield Output: %f" % current_shield_output)
