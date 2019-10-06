extends Node

const img_size = 16
const overlays_per_img = 10

var textures = {}
var images = {}

var tgt_gens = ["Rock", "Tree"]

var algo = {
	"Rock": {
		base_color = Color(192.0/255.0, 192.0/255.0, 192.0/255.0, 1),
		noise = 1,
		island = 1,
		islandm = 1.0,
		alphacutoff = 0.4,
		
		shadow = 0.3,
		shadowsq = 12,
		
		noiseOct = 4.0,
		noisePer = 10.0,
		noisePers = 0.3
		
	},
	
	"Tree": {
		base_color = Color(128.0/255.0, 192.0/255.0, 72.0/255.0, 1),
		noise = 0.8,
		island = 2,
		islandm = 2.0,
		alphacutoff = 0.3,
		
		shadow = 0.5,
		shadowsq = 2,
		
		noiseOct = 3.0,
		noisePer = 100.0,
		noisePers = 12.3,
		
		random_dodge = 6,
		dodge_mult = 0.5,
		random_burn = 3,
		burn_mult = 0.8,
		random_hue_p = 12,
		random_hue_g = 32,
	}
}

func generate_texture(img: Image, gen_type):
	if(not(algo.has(gen_type))):
		return
	
	randomize()
	
	var algodat = algo[gen_type]
	
	var noisegen = OpenSimplexNoise.new()
	noisegen.seed = randi()
	noisegen.octaves = algodat.get("noiseOct", 2.0)
	noisegen.period = algodat.get("noisePer", 50.0)
	noisegen.persistence = algodat.get("noisePers", 0.5)
	
	
	img.lock()
	
	
	var base_col:Color = algodat["base_color"]
	base_col.h += (randf() - 0.5) * (algodat.get("random_hue_g", 0)/360.0)
	
	var xmin = img_size
	var ymin = img_size
	var xmax = 0
	var ymax = 0
	
	for x in range(img_size):
		for y in range(img_size):
			var out_col:Color = base_col
			
			
			
			var noisev = algodat.get("noise", 0)
			var noise = ((noisegen.get_noise_2d(x, y)+1)/2)
			noise = 1.0 + (noise - 1.0) * noisev
			
			var islandv = algodat.get("island", 0)
			
			var islandmult = algodat.get("islandm", 1)
			
			var vx = x+0.5
			var vy = y+0.5
			
			islandmult *= -(1.0/(img_size*(img_size/4.0))) * (vx * vx) + (1.0/(img_size/4.0)) * vx
			islandmult *= -(1.0/(img_size*(img_size/4.0))) * (vy * vy) + (1.0/(img_size/4.0)) * vy
			
			islandmult = clamp(islandmult, 0, 1)
			
			for i in range(islandv):
				noise *= islandmult
			
			
			var alphacutoffv = algodat.get("alphacutoff", 0)
			
			var a = noise
			
			if(alphacutoffv != 0):
				a = 1 if noise > alphacutoffv else 0
			
			out_col.a = a
			
			var shadowmast = (1-(noise-alphacutoffv))
			var shadowadd = shadowmast
			for i in range(algodat.get("shadowsq", 0)):
				shadowadd *= shadowmast
			
			out_col = out_col.darkened(
				clamp(shadowadd*algodat.get("shadow", 0), 0, 0.3)
			)
			
			
			var dodge = algodat.get("dodge_mult", 0)
			var burn = algodat.get("burn_mult", 0)
			for i in range(algodat.get("random_dodge", 0)):
				dodge *= randf()
			for i in range(algodat.get("random_burn", 0)):
				burn *= randf()
			out_col = out_col.lightened((clamp(dodge-burn, -0.5, 0.5)) * noise * noise)
			
			out_col.h += (randf() - 0.5) * (algodat.get("random_hue_p", 0)/360.0)
			
			if(out_col.a > 0):
				xmin = min(x, xmin)
				ymin = min(y, ymin)
				xmax = max(x, xmax)
				ymax = max(y, ymax)
				img.set_pixel(x, y, out_col)
			
			
	
	# avoid generating textures too small
	var dx = xmax-xmin
	var dy = ymax-ymin
	if((dx*dy) < ((img_size/3)*(img_size/3))):
		return generate_texture(img, gen_type)
	img.unlock()

func _ready():
	for v in tgt_gens:
		
		
		
		var img = Image.new()
		img.create(img_size, img_size, false, Image.FORMAT_RGBA8)
		img.fill(Color(0, 0, 0, 0))
		images[v] = img
		
		textures[v] = []
		
		textures[v].resize(overlays_per_img)
		
		for i in range(overlays_per_img):
			generate_texture(img, v)
			var tex = ImageTexture.new()
			tex.create_from_image(img, ImageTexture.FLAG_REPEAT)
			textures[v][i] = tex

func get_tgt_gens():
	return tgt_gens

func get_textures(idx):
	return textures[idx]

func get_texture_size():
	return img_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
