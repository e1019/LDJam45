extends Node

func Color3(r, g, b):
	return Color(r/255.0, g/255.0, b/255.0, 1.0)

func poar(arr, strict):
	var r: Color = arr[randi() % len(arr)]
	
	r.h += ((randf()-0.5)*(32 if strict else 256))/360
	
	return r

var skin_col_base = [
	Color3(206, 190, 150)
]

var shirts_base = [
	Color3(0, 148, 255),
	Color3(255, 148, 0)
]

var pants_base = [
	Color3(0, 38, 255),
	Color3(255, 38, 0)
]

var hair_base = [
	Color3(127, 53, 53),
	Color3(53, 53, 53),
	Color3(216, 168, 45)
]

var hat_base = [
	Color3(98, 70, 52)
]

var shoes_base = [
	Color3(25, 25, 25)
]

func is_col_dark(x, y):
	return ((x + (y % 2)) % 2) == 0

func generate():
	var img = Image.new()
	img.create(10, 10, false, Image.FORMAT_RGBA8)
	img.lock()
	
	# pick colors
	var skin = poar(skin_col_base, true)
	var shirt = poar(shirts_base, false)
	var pants = poar(pants_base, false)
	var shoes = poar(shoes_base, false)
	
	
	
	# fill head
	for x in range(6):
		for y in range(4):
			img.set_pixel(x+2, y+2, skin)
	
	# fill shirt
	for x in range(6):
		for y in range(2):
			img.set_pixel(x+2, y+6, shirt)
	
	# put hands
	img.set_pixel(2, 7, skin)
	img.set_pixel(7, 7, skin)
	
	# put pants
	for x in range(4):
		img.set_pixel(x+3, 8, pants)
	
	# put shoes
	img.set_pixel(3, 9, shoes)
	img.set_pixel(6, 9, shoes)
	
	# bald, hair or hat
	var bhh = randf()
	if(bhh < 0.3):
		# bald
		print("Bald")
	elif(bhh < 0.6):
		# hair
		var hair = poar(hair_base, false)
		var hair_shade = hair.darkened(0.1)
		
		var long_hair = randf() > 0.5
		
		var hair_data: Array
		
		if(long_hair):
			hair_data = [
				".#@@#@@.",
				"@#@##@##",
				"@@@#@@#@",
				"@......@",
				"@......@"
			]
		else:
			hair_data = [
				".#@@#@@.",
				"@#@##@##",
				"@@@#@@#@",
				"/....../"
			]
		var y = 0
		
		for y_str in hair_data:
			for x in range(len(y_str)):
				var ch = y_str[x]
				if(ch == "#"):
					img.set_pixel(x+1, y, hair)
				elif(ch == "@"):
					img.set_pixel(x+1, y, hair_shade)
			y += 1
	else:
		# hat
		var hat = poar(hat_base, false)
		var hat_shade = hat.darkened(0.1)
		
		var hat_data = [
			".######.",
			"@?####?@",
			".@@@@@@."
		]
		
		var rando = randf() < 0.5
		
		var y = 0
		for y_str in hat_data:
			for x in range(len(y_str)):
				var ch = y_str[x]
				if(ch == "#"):
					img.set_pixel(x+1, y, hat)
				elif(ch == "@"):
					img.set_pixel(x+1, y, hat_shade)
				elif(ch == "?"):
					img.set_pixel(x+1, y, hat_shade if rando else hat)
			y += 1
	
	# put eyes
	img.set_pixel(3, 3, Color3(0,0,0))
	img.set_pixel(3, 4, Color3(0,0,0))
	img.set_pixel(6, 3, Color3(0,0,0))
	img.set_pixel(6, 4, Color3(0,0,0))
	
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img, 0)
	
	return imgtex