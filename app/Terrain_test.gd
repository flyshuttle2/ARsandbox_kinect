extends MeshInstance3D

var reference_kinect 

var img = Image.new()
var img_colormap = Image.new()

@onready var character_body_3d = $"../CharacterBody3D"


var pixel

# 存储像素值等于0的数组
var filtered_vectors = []
var next_pos

var target_position = Vector3(5, 0, 0)  # 目标位置
var move_duration = 2.0  # 移动持续时间
var current_time = 0.0  # 当前时间
var start_position: Vector3  # 起始位置

func _ready():
	img.load("res://image - 副本.png")

	start_position = character_body_3d.position# 记录起始位置
	
	var thing_pixel = coordinates_space2pixel(start_position)
	
	var radius = 10
	get_area(thing_pixel,radius,filtered_vectors)
	
	# 在周围的像素点中取另一个像素点，将其转为空间坐标，然后让物体向这个坐标移动
#	var middle_index = filtered_vectors.size() / 2
#	var middle_element = filtered_vectors[middle_index]
	var random_index = randi() % filtered_vectors.size()
	var random_value = filtered_vectors[random_index]
	filtered_vectors.clear()
	# 将选择的中间像素坐标映射到空间坐标 ,
	next_pos = coordinates_pixel2space(random_value)

func _process(delta):
#	reference_kinect.update()
#	var frame_data = reference_kinect.get_depth_data()	
#
#	img = img.create(512, 424, false, Image.FORMAT_R8)
#
#	for y in range(0,424):
#		for x in range(0,512):
#			var value = frame_data.decode_s8(x+y*512)
#			img.set_pixel(x, y, Color(value,value,value ) ) # Sets the color at (1, 2) to red.
#	img.save_png("image.png")
#
	img.load("res://image - 副本.png")
	var texture = ImageTexture.create_from_image(img)
	
# 	Color get_pixelv(point: Vector2i) const
	img_colormap.load("res://4volcono1.png")	
	var texture_1 = ImageTexture.new()
	texture_1.create_from_image(img_colormap) #,0

	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)
	
	# 移动的逻辑 ，利用线性插值进行移送，或者利用动画进行移动
	current_time += delta
	if current_time > move_duration:
		current_time = move_duration

	var t = current_time / move_duration  # 计算插值系数
	character_body_3d.position = start_position.lerp(target_position, t)  # 进行线性插值

	if current_time >= move_duration:
		# 移动完成后执行额外的逻辑
		_on_move_complete()
		pass

func _physics_process(delta):
	# 向目标位置移动
#	character_body_3d.move_and_slide(next_pos,Vector3.UP)
	
	pass

func _on_move_complete():
	# 移动完成后的逻辑
	# 移动完成后更新下一个点的位置
	print("移动完成")

	target_position = Vector3(3,0,0)
	current_time = 0.0  # 当前时间
	start_position = character_body_3d.position # 更新起始位置
	print("start_position",start_position)
	
	var thing_pixel_coord = coordinates_space2pixel(start_position)
	print("thing_pixel_coord",thing_pixel_coord)
	
	var radius = 10
	get_area(thing_pixel_coord,radius,filtered_vectors)
	# 在周围的像素点中取另一个像素点，将其转为空间坐标，然后让物体向这个坐标移动
	var random_index = randi() % filtered_vectors.size()
	var random_value = filtered_vectors[random_index]
	filtered_vectors.clear()
	
	print("middle_element",random_value)
	# 将选择的中间像素坐标映射到空间坐标 ,
	target_position = coordinates_pixel2space(random_value)
#	target_position.x += randi() % 2 + randf()
#	target_position.z += randi() % 2 + randf()
	
	print("target_position",target_position)
	
# 将移动物体的空间坐标
func coordinates_space2pixel(space_coord: Vector3)->Vector2:
	# 图片的大小
	var img_size = img.get_size()
	# 地形的大小
	var terrain_size = self.mesh.size
	
	# 图片像素坐标和物体坐标之间的映射,
	var pixel_coord_x =  space_coord.x * (img_size.x / terrain_size.x)
	var pixel_coord_y =  space_coord.y * (img_size.y / terrain_size.y)
	# int()：将浮点数舍入到最接近的整数。
	return Vector2(int(pixel_coord_x),int(pixel_coord_y))
	
# 将像素坐标映射到空间坐标 ,
func coordinates_pixel2space(pixel_coord: Vector2)->Vector3:
	# 图片的大小
	var img_size = img.get_size()
	# 地形的大小
	var terrain_size = self.mesh.size
	
	var pixel_space_x =   pixel_coord.x  *(terrain_size.x / img_size.x )
	var pixel_space_y =   pixel_coord.y  *(terrain_size.y / img_size.y )
	
	return Vector3(pixel_space_x,0,pixel_space_y)


# 图片上以A点为中心，获取在半径radiu范围的所有像素值
func get_area(pos:Vector2,radius:int,filtered_vectors:Array):
	for y in range(pos.y - radius, pos.y + radius + 1):
		for x in range(pos.x - radius, pos.x + radius + 1):
			if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
				# 在区域内的像素点上执行操作
#				image.set_pixel(x, y, Color.red())
				# 得到坐标的像素值，坐标需要整数
				pixel = img.get_pixel(x ,y)
#				print(x,y)
				var vector = Vector2(x, y)
				if pixel.r < 10:
					filtered_vectors.append(vector)
	


