class_name CallPromise extends Timer


func _init(time: float, callable: Callable):
	wait_time = time
	autostart = true
	
	await ready
	timeout.connect(queue_free)
	timeout.connect(callable)




static func resolver_bhaskara(a: int, b: int, c: int):
	var p1 = pow(b, 2) - (4 * a * c)
	if p1 < 0.0:
		return "deu erro ai, teu DELTA resultou em negativo: " + str(p1)
	
	var p2 = b * -1
	var p3 = 2 * a
	
	return "os resultados da equação são: " + str((p2 + sqrt(p1)) / p3) + " e " + str((p2 - sqrt(p1)) / p3)
