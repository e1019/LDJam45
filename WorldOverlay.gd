extends TileMap

var tileset

var ids = {}

func gen_overlay():
	tileset = TileSet.new()
	var t_size = $OverlayTextureGen.get_texture_size()
	var textures = $OverlayTextureGen.get_tgt_gens()
	
	var counter = 0
	
	
	for k in range(len(textures)):
		var tex_name = textures[k]
		var v = $OverlayTextureGen.get_textures(tex_name)
		
		ids[tex_name] = []
		
		for i in range($OverlayTextureGen.overlays_per_img):
			tileset.create_tile(counter)
			tileset.tile_set_texture(counter, v[i])
			ids[tex_name].append(counter)
			counter += 1
	
	tile_set = tileset
	cell_size = Vector2(t_size, t_size)
	
	var szx = get_parent().islandSizeX
	var szy = get_parent().islandSizeY
	
	for i in range(szx * (szy/24)):
		var x = randi() % (szx/2) - (szx/4)
		var y = randi() % (szy/2) - (szy/4)
		
		var cell = get_parent().get_cell(x*2, y*2)
		if(cell != get_parent().get_cell((x*2)+1, y*2)):
			continue
		if(cell != get_parent().get_cell(x*2, (y*2)+1)):
			continue
		if(cell != get_parent().get_cell((x*2)+1, (y*2)+1)):
			continue
		
		if(cell != 0):
			var tile_type = "Rock" if (cell == 1) else "Tree"
			var tile = ids[tile_type][randi() % len(ids[tile_type])]
			set_cell(x, y, tile)