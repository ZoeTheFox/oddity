extends RigidBody3D

@onready
var thrusters = $Thrusters.main_thrusters

var main
var main2

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node("Thrusters/" + str(thrusters[0]))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_force(main.thrust_vector, main.thrust_position)

