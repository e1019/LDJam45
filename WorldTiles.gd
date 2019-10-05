extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var tileset

var xmin: int
var ymin: int
var xmax: int
var ymax: int

func _ready():
	tileset = TileSet.new()
	var t_size = $TextureGen.get_texture_size()
	var textures = $TextureGen.get_tgt_gens()
	
	var TileArray = {}
	
	for k in range(len(textures)):
		var tex_name = textures[k]
		var v = $TextureGen.get_texture(tex_name)
		
		print(k, tex_name, v)
		
		tileset.create_tile(k)
		tileset.tile_set_texture(k, v)
		
		TileArray[tex_name] = k
	
	cell_size = Vector2(t_size, t_size)
	
	tile_set = tileset
	
	var islandSizeX = 256
	var islandSizeY = 256
	
	var mapdata = $IslandGen.generate_islandmap(islandSizeX, islandSizeY, TileArray)
	
	var map = mapdata[0]
	
	xmin = map[1]
	ymin = map[2]
	xmax = map[3]
	ymax = map[4]
	
	print("limits", xmin, ymin, xmax, ymax)
	
	for x in range(islandSizeX):
		for y in range(islandSizeY):
			var idx = $IslandGen.pack(x, y, islandSizeX, islandSizeY)
			set_cell(x - islandSizeX/2, y - islandSizeY/2, map[idx])

func getLimits():
	return [Vector2(xmin, ymin), Vector2(xmax, ymax)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
