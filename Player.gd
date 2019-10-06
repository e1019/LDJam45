extends Node2D

var dead = false

var speed = 1

func _process(delta):
	if(dead):
		return
	
	var limits = owner.get_node("WorldTerrain").getLimits()
	
	var down = Input.get_action_strength("move_down")
	var up = Input.get_action_strength("move_up")
	var left = Input.get_action_strength("move_left")
	var right = Input.get_action_strength("move_right")
	
	var velocity = Vector2(right-left, down-up)
	if(velocity.length() > 1):
		velocity /= velocity.length()
	
	velocity *= 60*delta*speed
	
	translate(velocity)
	
	position = Vector2(clamp(position.x, limits[0].x, limits[1].x), clamp(position.y, limits[0].y, limits[1].y))
	
	
	get_parent().get_node("VisiblePlayer").on_move(up, left, down, right)

func die():
	dead = true