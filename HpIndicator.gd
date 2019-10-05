extends Control

var curr_hp:int = 0
var curr_max_hp:int = 0

var curr_hp_texes:Array = []

var hp_full: Resource
var hp_empty: Resource

var hp_mat: Resource

var to_rem:Array = []

func _ready():
	hp_full = preload("res://resources/hp.tres")
	hp_empty = preload("res://resources/hpoutline.tres")
	
	hp_mat = preload("res://resources/material0.tres")

func onHealthChanged(new_hp: int, new_max:int):
	if(curr_max_hp > new_max):
		for i in range(new_max, curr_max_hp):
			var tx: TextureRect = curr_hp_texes[i]
			remove_child(tx)
		curr_hp_texes.resize(new_max)
	elif(curr_max_hp < new_max):
		curr_hp_texes.resize(new_max)
		for i in range(curr_max_hp, new_max):
			var tx: TextureRect = TextureRect.new()
			tx.margin_bottom = 40
			tx.margin_left = 42*i
			tx.margin_right = 42*i+40
			tx.margin_top = 0
			tx.texture = hp_full if (i < new_hp) else hp_empty
			tx.stretch_mode = TextureRect.STRETCH_SCALE
			tx.material = hp_mat
			add_child(tx)
			to_rem.append(tx)
			curr_hp_texes[i] = tx
	
	
	if(new_hp > curr_hp):
		for i in range(curr_hp, new_hp):
			var tx:TextureRect = curr_hp_texes[i]
			tx.material = hp_mat
			tx.texture = hp_full
			to_rem.append(tx)
	elif(curr_hp > new_hp):
		if(new_hp > 0):
			$Harm.play()
		for i in range(new_hp, curr_hp):
			var tx:TextureRect = curr_hp_texes[i]
			tx.material = hp_mat
			tx.texture = hp_empty
			to_rem.append(tx)
	
	curr_hp = new_hp
	curr_max_hp = new_max
	
var timer = 0

func _process(dt):
	if(len(to_rem) > 0):
		timer += dt
	else:
		timer = 0
	
	if(timer > 1.0/10.0):
		for v in to_rem:
			v.material = null
		to_rem.clear()
		timer = 0