extends Node3D

var total_fuel_capacity : float
var count_fuel_tanks : int

var current_fuel_capacity : float

# Called when the node enters the scene tree for the first time.
func _ready():
	count_fuel_tanks = get_child_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total_fuel_capacity = count_fuel()
	current_fuel_capacity = get_current_fuel_capacity()
	
	#print(current_fuel_capacity)

func count_fuel() -> float:
	var fuel : float
	
	for fuel_tank in get_children():
		fuel += fuel_tank.fuel_capacity
	
	return fuel

func use_fuel(amount : float):
	var fuel_per_tank = amount / count_fuel_tanks * get_process_delta_time()
	
	for fuel_tank in get_children():
		fuel_tank.use_fuel(fuel_per_tank)
	
func get_current_fuel_capacity():
	var fuel : float
	
	for fuel_tank in get_children():
		fuel += fuel_tank.current_fuel
	
	return fuel
