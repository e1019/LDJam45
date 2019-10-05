extends Sprite

var MovingPlayer:Node2D



func _ready():
	var tex = $PlayerGen.generate()
	texture = tex


#func _process(delta):
#	pass