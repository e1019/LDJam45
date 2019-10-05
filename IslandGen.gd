extends Node

func pack(x, y, xmult, ymult):
	return x + y*xmult

func generate_islandmap(xSize, ySize, TileArray):
	var result = PoolByteArray()
	result.resize(xSize * ySize)
	
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 3
	noise.period = 20.0
	noise.persistence = 0.8
	
	var xmin = xSize
	var ymin = ySize
	var xmax = 0
	var ymax = 0
	
	for x in range(xSize):
		for y in range(ySize):
			var r = noise.get_noise_2d(x, y)
			r += 1
			r /= 2.0
			var id = -1
			
			var centermultiplier = 1
			centermultiplier *= -(1.0/(xSize*(xSize/4.0))) * (x * x) + (1.0/(xSize/4.0)) * x
			centermultiplier *= -(1.0/(ySize*(ySize/4.0))) * (y * y) + (1.0/(ySize/4.0)) * y
			
			r *= centermultiplier
			
			var wasntWater = true
			
			if(r > 0.5):
				id = TileArray["Grass"]
			elif(r > 0.4):
				id = TileArray["Sand"]
			else:
				id = TileArray["Water"]
				wasntWater = false
			
			if(wasntWater):
				xmin = min(xmin, x)
				ymin = min(ymin, y)
				xmax = max(xmax, x)
				ymax = max(ymax, y)
			
			result[pack(x, y, xSize, ySize)] = id
	
	return [result, xmin, ymin, xmax, ymax]