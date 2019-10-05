extends Label

var frames = 0
var time = 0

func _process(delta):
	time += delta
	frames += 1
	
	if(time > 0.5):
		var fps = str((frames/time))
		text = "FPS: " + fps
		frames = 0
		time = 0