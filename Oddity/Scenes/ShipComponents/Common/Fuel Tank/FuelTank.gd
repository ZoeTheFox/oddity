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

var current_fuel : float
var wear : float


# Called when the node enters the scene tree for the first time.
func _ready():
	current_fuel = fuel_capacity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use_fuel(amount : float):
	current_fuel -= amount
