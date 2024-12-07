class_name Queue
extends Path3D

@export var max_queue_size: int = 10
@export var customer_scene: PackedScene

var queue: Array = []
var next_id: int = 1

func _process(delta: float) -> void:
	var queue_size := queue.size()
	
	for i in range(queue_size):
		var customer = queue[i]
		# Move the customers towards their progress limit, unless they already 
		# reached it.
		if customer.progress < customer.max_progress:
			customer.progress += delta * 5
		else:
			# If the customers are not moving, increase their impatience
			customer.impatience = \
					clamp(customer.impatience + delta * 20, 0.0, 100.0)


## Spawn timer creates new customer objects
func _on_spawn_timer_timeout() -> void:
	var new_customer: Customer = customer_scene.instantiate()
	new_customer.id = next_id
	next_id += 1
	add_child(new_customer)
	# Don't forget to add the new customer to the queue
	queue.append(new_customer)
	
	var queue_size := queue.size()
	var path_length := curve.get_baked_length()
	# Recalculate the progress limit for all customers based on the length of
	# the curve and their position in the queue.
	for i in range(queue_size):
		queue[i].max_progress = path_length - i * 5
		#prints("max_progress", i, "=", queue[i].max_progress)
