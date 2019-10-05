extends Node2D


func _process(delta):
	
	var limits = owner.get_node("WorldTiles").getLimits()
	
	var down = Input.get_action_strength("move_down")
	var up = Input.get_action_strength("move_up")
	var left = Input.get_action_strength("move_left")
	var right = Input.get_action_strength("move_right")
	
	var velocity = Vector2(right-left, down-up)
	if(velocity.length() > 1):
		velocity /= velocity.length()
	
	print(limits[0], limits[1])
	
	translate(velocity)
	
	position = Vector2(clamp(position.x, limits[0].x, limits[1].x), clamp(position.y, limits[0].y, limits[1].y))