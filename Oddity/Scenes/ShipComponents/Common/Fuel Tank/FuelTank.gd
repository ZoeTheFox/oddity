extends Node3D

@export_category("Manufacturer Information")

@export
var manufacturer : String

@export
var model : String

@export_category("Component Information")

@export_range(0, 10, 1)
var size_class : int

@export
var fuel_capacity : float

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

@export
var current_fuel : float
var wear : float

@export
var fuel_quality : float



# Called when the node enters the scene tree for the first time.
func _ready():
	current_fuel = fuel_capacity
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use_fuel(amount : float):
	current_fuel -= amount * get_process_delta_time()

func add_fuel(amount : float, quality : float):
	amount = amount * get_process_delta_time()
	
	if ((amount + current_fuel) > fuel_capacity):
		return
	
	# Calculate the total amount of fuel after adding
	var total_fuel = current_fuel + amount 

	# Calculate the weighted average of the fuel qualities
	var total_quality = (current_fuel * fuel_quality) + (amount * quality)
	fuel_quality = total_quality / total_fuel

	# Update the current fuel amount
	current_fuel = total_fuel
