class_name CallPromise extends Timer


func _init(time: float, callable: Callable):
	wait_time = time
	autostart = true
	
	await ready
	timeout.connect(queue_free)
	timeout.connect(callable)



