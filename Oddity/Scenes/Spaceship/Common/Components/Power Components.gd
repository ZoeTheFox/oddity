extends Node3D

var component_list : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(component_list)

func request_power(component : Node3D):	
	return $"Power Plants".request_power(component.required_power)
	
func reset_power():
	$"Power Plants".reset_power_on_tick()

	
	#component_list.append(component)


