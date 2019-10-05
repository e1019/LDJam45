extends Control

var dead = false
var dead_time = 0

func _ready():
	$TextureRect.visible = false

func die():
	$TextureRect.visible = true
	$DeathAudio.play(0)
	dead = true

func _process(dt):
	if(dead):
		dead_time += dt
		if(dead_time > 10):
			get_tree().reload_current_scene()