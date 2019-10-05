extends Node2D

var health: int
var max_health: int

var worldTiles: TileMap

var dead = false

func update_pos():
	$VisiblePlayer.position = (($Mover.position/8).floor() * 8)



func get_under_tile():
	return worldTiles.get_cellv($VisiblePlayer.position/worldTiles.cell_size)

func find_spawn_pos():
	while(get_under_tile() == 0):
		$Mover.position += Vector2(10, 10)
		update_pos()



func _ready():
	health = 5
	max_health = 6
	update_hp()
	
	$VisiblePlayer/Camera2D.make_current()
	worldTiles = get_parent().get_node("WorldTiles")
	find_spawn_pos()



func update_hp():
	$LocalUI.change_hp(health, max_health)

func setHealth(hp: int):
	health = clamp(hp, 0, max_health)
	update_hp()
	
	if((health <= 0) and not dead):
		dead = true
		print("We dead")
		$Mover.die()
		$LocalUI.die()

func setMaxHealth(maxhp: int):
	max_health = max(0, maxhp)
	update_hp()

var water_timer = 0.0

func _process(dt):
	if(get_under_tile() == 0):
		water_timer += dt
		if(water_timer > 1):
			setHealth(health-1)
			water_timer = 0
		
		$Mover.speed = 1.0/3.0
	else:
		$Mover.speed = 1.0
		water_timer -= dt
		if(water_timer < -2):
			setHealth(health+1)
			water_timer = 0
	
	update_pos()