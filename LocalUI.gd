extends CanvasLayer

func change_hp(hp:int, maxhp:int):
	$HpIndicator.onHealthChanged(hp, maxhp)

func die():
	$Death.die()