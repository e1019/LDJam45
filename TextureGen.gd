extends Node

const img_size = 8

var textures = {}
var images = {}

var tgt_gens = ["Water", "Sand", "Grass"]


var algo = {
	"Sand": {
		base_color = Color(229.0/255.0, 215.0/255.0, 181.0/255.0, 1.0),
		random_dodge = 6,
		dodge_mult = 3,
		random_burn = 3,
		burn_mult = 1
	},
	"Grass": {
		base_color = Color(0.0/255.0, 173.0/255.0, 95.0/255.0, 1.0),
		random_dodge = 4,
		dodge_mult = 0.6,
		random_burn = 2,
		burn_mult = 0.4
	}
}

func generate_texture(img: Image, gen_type):
	if(not(algo.has(gen_type))):
		return
	
	randomize()
	
	var algodat = algo[gen_type]
	
	img.lock()
	for x in range(img_size):
		for y in range(img_size):
			var comput_col: Color = algodat["base_color"]
			var dodge = algodat.get("dodge_mult", 0)
			var burn = algodat.get("burn_mult", 0)
			for i in range(algodat.get("random_dodge", 0)):
				dodge *= randf()
			for i in range(algodat.get("random_burn", 0)):
				burn *= randf()
			comput_col = comput_col.lightened(clamp(dodge-burn, -0.5, 0.5))
			
			img.set_pixel(x, y, comput_col)
	img.unlock()

func _ready():
	for v in tgt_gens:

		
		if(not has_node(v)):
			var img = Image.new()
			img.create(img_size, img_size, false, Image.FORMAT_RGBA8)
			generate_texture(img, v)
			images[v] = img
			
			var tex = ImageTexture.new()
			tex.create_from_image(img, ImageTexture.FLAG_REPEAT)
			textures[v] = tex
		else:
			var node = get_node(v)
			images[v] = node.get_image()
			textures[v] = node.get_imageTexture()

func get_tgt_gens():
	return tgt_gens

func get_texture(idx):
	return textures[idx]

func get_texture_size():
	return img_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
