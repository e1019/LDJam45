extends Control

var curr_logs:int = 0
var curr_max_logs:int = 0

var curr_hp_texes:Array = []

var log_full: Resource
var log_empty: Resource

var hp_mat: Resource

var to_rem:Array = []

func _ready():
	log_full = preload("res://resources/logfull.tres")
	log_empty = preload("res://resources/logblank.tres")
	
	hp_mat = preload("res://resources/material0.tres")

func onWoodChanged(new_log: int, new_max:int):
	if(curr_max_logs > new_max):
		for i in range(new_max, curr_max_logs):
			var tx: TextureRect = curr_hp_texes[i]
			remove_child(tx)
		curr_hp_texes.resize(new_max)
	elif(curr_max_logs < new_max):
		curr_hp_texes.resize(new_max)
		for i in range(curr_max_logs, new_max):
			var tx: TextureRect = TextureRect.new()
			tx.margin_bottom = 42*i+40
			tx.margin_left = 0
			tx.margin_right = 40
			tx.margin_top = 42*i
			tx.texture = log_full if (i < new_log) else log_empty
			tx.stretch_mode = TextureRect.STRETCH_SCALE
			tx.material = hp_mat
			add_child(tx)
			to_rem.append(tx)
			curr_hp_texes[i] = tx
	
	
	if(new_log > curr_logs):
		$Break.play()
		for i in range(curr_logs, new_log):
			var tx:TextureRect = curr_hp_texes[i]
			tx.material = hp_mat
			tx.texture = log_full
			to_rem.append(tx)
	elif(curr_logs > new_log):
		$Build.play()
		for i in range(new_log, curr_logs):
			var tx:TextureRect = curr_hp_texes[i]
			tx.material = hp_mat
			tx.texture = log_empty
			to_rem.append(tx)
	
	curr_logs = new_log
	curr_max_logs = new_max
	
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