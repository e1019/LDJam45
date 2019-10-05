extends Sprite

var MovingPlayer:Node2D

func _ready():
	MovingPlayer = get_parent().get_node("Mover")
	$Camera2D.make_current()


func _process(delta):
	position = ((MovingPlayer.position/8).floor() * 8) + Vector2(4, 4)