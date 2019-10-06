extends Node2D

var health: int
var max_health: int

var worldTiles: TileMap
var overlayTiles: TileMap

var dead = false

var logs: int = 0
var maxlogs: int = 12

var floorpos = Vector2(0, 0)
var prev_floorpos = Vector2(0, 0)



func get_under_overlay_tile():
	var csfloorpos = (($Mover.position/16).floor() * 16)
	return overlayTiles.get_cellv(csfloorpos/overlayTiles.cell_size)

func get_overlay_pos(offset: Vector2):
	return ((($Mover.position/16).floor() * 16)/overlayTiles.cell_size) + offset

func get_under_overlay_tile_offset(offset: Vector2):
	return overlayTiles.get_cellv(get_overlay_pos(offset))

func place_wood():
	if(logs <= 0):
		return false
	var tries = [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	for x in tries:
		if(get_under_tile_offset(x) == 0):
			var overpos = get_tile_offset(x)
			worldTiles.set_cellv(overpos, 3)
			logs = clamp(logs - 1, 0, maxlogs)
			$LocalUI/WoodIndicator.onWoodChanged(logs, maxlogs)
			return true
	return false

func cut_wood():
	
	var tries = [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	for x in tries:
		if(get_under_overlay_tile_offset(x) > 9):
			if(logs == maxlogs):
				continue
			var overpos = get_overlay_pos(x)
			overlayTiles.set_cellv(overpos, -1)
			logs = clamp(logs + 3, 0, maxlogs)
			$LocalUI/WoodIndicator.onWoodChanged(logs, maxlogs)
			return true
		elif(get_under_overlay_tile_offset(x) > -1):
			if(logs < 2):
				continue
			var overpos = get_overlay_pos(x)
			overlayTiles.set_cellv(overpos, -1)
			logs = clamp(logs -2, 0, maxlogs)
			health = clamp(health + 1, 0, max_health)
			$LocalUI/WoodIndicator.onWoodChanged(logs, maxlogs)
			update_hp()
			return true
	return false

func collide():
	var under_tile = get_under_overlay_tile()
	if(under_tile != -1):
		if(floorpos != prev_floorpos):
			floorpos = prev_floorpos
		else:
			while(get_under_overlay_tile() != -1):
				floorpos -= Vector2(0, 1)
				$Mover.position = floorpos
		
		$Mover.position = floorpos
	
	prev_floorpos = floorpos

func update_pos():
	floorpos = (($Mover.position/8).floor() * 8)
	collide()
	$VisiblePlayer.position = floorpos#$Mover.position



func get_under_tile():
	if(worldTiles == null):
		return -1
	return worldTiles.get_cellv(floorpos/worldTiles.cell_size)
func get_under_tile_offset(offset:Vector2):
	if(worldTiles == null):
		return -1
	return worldTiles.get_cellv(get_tile_offset(offset))
func get_tile_offset(offset:Vector2):
	return floorpos/worldTiles.cell_size + offset

func find_spawn_pos():
	while(get_under_tile() == 0):
		$Mover.position += Vector2(10, 10)
		update_pos()



func _ready():
	health = 1
	max_health = 6
	update_hp()
	
	$VisiblePlayer/Camera2D.make_current()
	worldTiles = get_parent().get_node("WorldTerrain")
	overlayTiles = worldTiles.get_node("WorldOverlay")
	find_spawn_pos()
	
	$LocalUI/WoodIndicator.onWoodChanged(logs, maxlogs)



func update_hp():
	$LocalUI.change_hp(health, max_health)

func setHealth(hp: int):
	health = clamp(hp, 0, max_health)
	update_hp()
	
	if((health <= 0) and not dead):
		dead = true
		$Mover.die()
		$LocalUI.die()
		$VisiblePlayer.die()

func setMaxHealth(maxhp: int):
	max_health = max(0, maxhp)
	update_hp()

var water_timer = 0.0

func _process(dt):
	if dead:
		return
	if(get_under_tile() == 0):
		water_timer += dt
		if(water_timer > 1):
			setHealth(health-1)
			water_timer = 0
		
		$Mover.speed = 1.0/3.0
	else:
		$Mover.speed = 1.0
		#water_timer -= dt
		#if(water_timer < -2):
		#	setHealth(health+1)
		water_timer = 0
	
	update_pos()
	
	if(Input.is_action_just_pressed("action")):
		if (not cut_wood()):
			place_wood()