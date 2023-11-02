extends Node3D

var rotationSpeed = 10.0  # Geschwindigkeit der Rotation
var numClones = 10  # Anzahl der Klone
var cloneDistance = 50.0  # Maximaler Abstand der Klone vom Original
var asteroidScene = preload("res://Scenes/Asteroids/Asteroid1/asteroid.tscn")

var clones = []  # Liste für die geklonten Asteroiden

func _ready():
	for i in range(numClones):
		var clone = asteroidScene.instantiate()
		var randomPosition = Vector3(randf_range(-cloneDistance, cloneDistance), randf_range(-cloneDistance, cloneDistance), randf_range(-cloneDistance, cloneDistance))
		clone.transform.origin = randomPosition
		add_child(clone)
		clones.append(clone)

func _process(delta):
	for clone in clones:
		var rotationAxis = Vector3(randf(), randf(), randf()).normalized()
		var currentRotation = clone.rotation_degrees
		currentRotation += rotationAxis * rotationSpeed * delta
		clone.rotation_degrees = currentRotation
