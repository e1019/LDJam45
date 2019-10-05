extends Node

const size = 8

var img: Image
var imageTexture: ImageTexture

var soupHeat: PoolRealArray
var potHeat: PoolRealArray
var flameHeat: PoolRealArray

var timer = 0

func pack_wrap(x, y):
	return (x % size) + (y % size)*size

func tick_animation():
	img.lock()
	for x in range(size):
		for y in range(size):
			var this_pack = pack_wrap(x, y)
			var localSoupHeat = soupHeat[pack_wrap(x-1, y)] + soupHeat[this_pack] + soupHeat[pack_wrap(x+1, y)]
			soupHeat[this_pack] = (localSoupHeat / 3.3) + potHeat[this_pack] * 0.8
			potHeat[this_pack] = max(potHeat[this_pack] + flameHeat[this_pack] * 0.05, 0)
			flameHeat[this_pack] = flameHeat[this_pack] - 0.1
			if(randf() < 0.05):
				flameHeat[this_pack] = 0.5
			
			var colorHeat = clamp(soupHeat[this_pack], 0.0, 1.0)
			var colorHeatsq = colorHeat*colorHeat
			
			
			var r = 24.0 + colorHeatsq * 64.0
			var g = 128.0 + colorHeatsq * 64.0
			var b = 183.0 + colorHeatsq * 72.0
			var a = 146.0 + colorHeatsq * 50.0
			
			img.set_pixel(x, y, Color(r/255.0, g/255.0, b/255.0, a/255.0))
	img.unlock()
	imageTexture.set_data(img)

func setuparrays():
	soupHeat = PoolRealArray()
	soupHeat.resize(size*size)
	

	
	potHeat = PoolRealArray()
	potHeat.resize(size*size)
	
	flameHeat = PoolRealArray()
	flameHeat.resize(size*size)
	
	for x in range(size):
		for y in range(size):
			var this_pack = pack_wrap(x, y)
			soupHeat[this_pack] = 0
			potHeat[this_pack] = 0
			flameHeat[this_pack] = 0
	

func setupimages():
	imageTexture = ImageTexture.new() 
	img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 1))
	tick_animation()
	imageTexture.create_from_image(img, ImageTexture.FLAG_REPEAT)

func _ready():
	setuparrays()
	setupimages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(timer > 1.0/16.0):
		tick_animation()
		timer = 0


func get_imageTexture():
	return imageTexture

func get_image():
	return img