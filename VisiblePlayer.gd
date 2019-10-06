extends Sprite

var MovingPlayer:Node2D

var textures:Array

var walking_counter = 0
var walking_idx = 0

var walk_snds = []

var walk_idx = 0

func play_walk():
	walk_idx = (walk_idx + 1) % 4
	var walk_snd = walk_snds[walk_idx]
	$walk.stream = walk_snd
	$walk.play()

func on_move(w, a, s, d):
	var tex_base: Array
	if a > 0:
		tex_base = textures[1]
	elif d > 0:
		tex_base = textures[3]
	elif w > 0:
		tex_base = textures[2]
	else:
		tex_base = textures[0]
	
	var dx = d-a
	var dy = w-s
	
	var dist = clamp(sqrt(dx * dx + dy * dy), 0, 1)
	
	
	walking_counter += dist
	
	var isInWater = get_parent().get_under_tile() == 0
	
	if((walking_counter > 6) and not isInWater):
		walking_idx += 1
		walking_counter = 0
		play_walk()
	
	walking_idx = walking_idx % 2
	
	
	
	texture = tex_base[3 if isInWater else ((1 + walking_idx) if dist > 0 else 0)]
	


func _ready():
	textures = $PlayerGen.generate()
	on_move(0, 0, 0, 0)
	walk_snds.append(preload("res://assets/walk0.wav"))
	walk_snds.append(preload("res://assets/walk1.wav"))
	walk_snds.append(preload("res://assets/walk2.wav"))
	walk_snds.append(preload("res://assets/walk3.wav"))

func die():
	modulate = Color(0, 0, 0, 1)

#func _process(delta):
#	pass