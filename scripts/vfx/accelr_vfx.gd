extends ReactorVFX


func _start():
	timer.start(0.35)
	await timer.timeout
	particles.emitting = true
	halos()



