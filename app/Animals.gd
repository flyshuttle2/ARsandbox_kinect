#extends MeshInstance3D
extends Node3D




var img = Image.new()

# 地形Mesh
@onready var terrain = $"../Terrain"


var pixel

# 存储像素值等于0的数组
var filtered_vectors = []
var next_pos

var target_position = Vector3(5, 0, 0)  # 目标位置
var move_duration = 1.0  # 移动持续时间
var current_time = 0.0  # 当前时间
var start_position: Vector3  # 起始位置

#var reference_kinect

func _ready():
	var new_boid = fish.instantiate()
	add_child(new_boid)
	#new_boid.initBoid(tankSize.x, tankSize.y, tankSize.z)
#	KinectSensor.reference_kinect.update()
#	var frame_data = KinectSensor.reference_kinect.get_depth_data()
#	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
#
#
#	img.load("res://graymapforblender - 副本.png")
#	start_position = mesh_instance_3d.position# 记录起始位置
#	var thing_pixel = coordinates_space2pixel(start_position)
#
#	var radius = 10
#	get_area(thing_pixel,radius,filtered_vectors)
#
#	# 在周围的像素点中取另一个像素点，将其转为空间坐标，然后让物体向这个坐标移动
##	var middle_index = filtered_vectors.size() / 2
##	var middle_element = filtered_vectors[middle_index]
#	var random_index = randi() % filtered_vectors.size()
#	var random_value = filtered_vectors[random_index]
#	filtered_vectors.clear()
#	# 将选择的中间像素坐标映射到空间坐标 ,
#	next_pos = coordinates_pixel2space(random_value)
#	pass
#
	
	
func _process(delta):

	pass
