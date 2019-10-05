extends CanvasLayer



func _ready():
	$bg.play()

func change_hp(hp:int, maxhp:int):
	$HpIndicator.onHealthChanged(hp, maxhp)

func die():
	$bg.stop()
	$Death.die()