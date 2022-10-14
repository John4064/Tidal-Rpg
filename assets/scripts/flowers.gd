extends Area2D



func _on_flowers_body_entered(body):
	if body.name == "Player":
		body.health +=15
		get_tree().queue_delete(self) # Replace with function body
		#body.score +=1 can access player attributes like this
