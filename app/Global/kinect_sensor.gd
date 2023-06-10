extends Node

var reference_kinect

@onready var config_file = 'res://SensorAreaConfig.txt'
var x_offset       #探测区域的X轴偏移
var y_offset       #探测区域的Y轴偏移
var x_length	   #探测区域的X方向长度
var y_length	   #探测区域的Y方向长度
var far_distance    #传感器到沙池底部的最远距离
var sand_maxdepth   #沙体的最大高度

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_config_file(config_file)
	
	reference_kinect = KinectV2.new()
	reference_kinect.set_parameter(far_distance, sand_maxdepth)
	
	
	
	
	
	
	
	
	
	pass # Replace with function body.

func load_config_file(config_file):

	var f = FileAccess.open(config_file, FileAccess.READ)
	
#	var index = 1
#	while not f.eof_reached(): # iterate through all lines until the end of file is reached
#		var line = f.get_line()
#		line += " "
#		print(line + str(index))
#		index += 1

	x_offset =  int(f.get_line())
	y_offset =  int(f.get_line())
	x_length =  int(f.get_line())
	y_length =  int(f.get_line())
	far_distance =  int(f.get_line())
	sand_maxdepth =  int(f.get_line())
		
	print(x_offset,y_offset,x_length,y_length,far_distance,sand_maxdepth)
	f.close()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
