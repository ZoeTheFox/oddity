extends GPUParticles3D

var max_particles = 256

func fire(throttle):

	if (round(throttle) == 0):
		emitting = false
	else:
		emitting = true
		amount = (throttle / 100.0) * max_particles + 1
