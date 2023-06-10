#extends MeshInstance3D
#
#
##var reference_kinect
#
#var img = Image.new()
#var imgCutten = Image.new()
#var img_colormap = Image.new()
#
#
##@onready var config_file = 'res://SensorAreaConfig.txt'
##
##
##var x_offset       #探测区域的X轴偏移
##var y_offset       #探测区域的Y轴偏移
##var x_length	   #探测区域的X方向长度
##var y_length	   #探测区域的Y方向长度
##var far_distance    #传感器到沙池底部的最远距离
##var sand_maxdepth   #沙体的最大高度
#
#
#var processed_frame_data : PackedByteArray 
#
#
#
#
#
#
#
#
## Use SimplexNoise if debug enabled, else use GDRealsense
## 如果是DEBUG，采用“开放简单噪声”来生成数据源
##var realsense = FastNoiseLite.new() if (DEBUG) else load("res://bin/x11/gdrealsense.gdns").new()
##var realsense = OpenSimplexNoise.new() if (DEBUG) else load("res://bin/x11/gdrealsense.gdns").new()
#
#
#
##var top_offset = 75
##var right_offset = 50
##var bottom_offset = 40
##var left_offset = 120
##var segment_size = 3
#
#
#
#
#
###读取传感器帧数据
##func get_frame():
##	var width : float
##	var height: float
##	var depth_array: PackedByteArray
##
##	#如果是DEBUG，则读取人工生成的数据；如果是运行状态，则从传感器中读取当前深度数据帧
##	if DEBUG:
##		realsense.seed = randi()
##		width = ceil((1280 - right_offset - left_offset)/segment_size) + 1
##		height = ceil((600 - top_offset - bottom_offset)/segment_size) + 1
##		depth_array = realsense.get_image(width, height).get_data()
##	else:
##		depth_array = realsense.get_depth_frame(top_offset, right_offset, bottom_offset, left_offset,segment_size)
##		width = realsense.get_frame_width()
##		height = realsense.get_frame_height()
##		print(width,height)
##	return {"width": width, "height": height, "depth_array": depth_array}
#
## 初始化：获取传感器帧图像，创建网格模型Called when the node enters the scene tree for the first time.
#func _ready():
#
##	print("hello")
##
##	load_config_file(config_file)
##
##	reference_kinect = KinectV2.new()
##	reference_kinect.set_parameter(far_distance, sand_maxdepth)
#
#
#
#
#
#
#	#processed_frame_data = 
#
##	material = mesh.material
##	rng.randomize()
##
##	#获取帧数据
##	var frame = get_frame()
##
##	#创建帧图像img
##	img = img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)
##	print(frame.width)	
##	print(frame.height)	
##	#print(frame.depth_array)		
##
##	print(img.get_size())
##	#print(img.get_data())
##	#清空初始化表面工具SurfaceTool
##	st.clear()
##	#开始创建三角形
##	st.begin(Mesh.PRIMITIVE_TRIANGLES)
##
##	var vert_x_width = frame.width - 1
##	var vert_y_height = frame.height - 1
##	for y in range(frame.height):
##		for x in range(frame.width):
##			#st.add_smooth_group(true)
##
##			#添加顶点
##			st.add_vertex(Vector3(((8.0*x)/(frame.width)), 0.0, ((4.5 * y)/(frame.height))))
##			# Build indices for a complete mesh
##			var vert_y = y
##			var vert_x = x
##			var next_vert_y = vert_y + 1
##			var next_vert_x = vert_x + 1
##			#将顶点添加到索引数组
##			if(vert_y < vert_y_height and vert_x < vert_x_width):
##				st.add_index((vert_x_width * vert_y) + vert_x)
##				st.add_index((vert_x_width * vert_y) + next_vert_x)
##				st.add_index((vert_x_width * next_vert_y) + next_vert_x)
##
##				st.add_index((vert_x_width * vert_y) + vert_x)
##				st.add_index((vert_x_width * next_vert_y) + next_vert_x)
##				st.add_index((vert_x_width * next_vert_y) + vert_x)
##
##	#设置模型材质
##	st.set_material(material)
##	# 完成模型生成，赋给变量mesh  Commit to a mesh.
##	mesh = st.commit()
##
##	#从模型创建网格数字工具MeshDataTool (MeshDataTool是编辑Mesh数据的工具)
##	mdt.create_from_surface(mesh, 0)
#
#
##
##func load_config_file(config_file):
##
##	var f = FileAccess.open(config_file, FileAccess.READ)
##
##	x_offset =  int(f.get_line())
##	y_offset =  int(f.get_line())
##	x_length =  int(f.get_line())
##	y_length =  int(f.get_line())
##	far_distance =  int(f.get_line())
##	sand_maxdepth =  int(f.get_line())
##
##	print(x_offset,y_offset,x_length,y_length,far_distance,sand_maxdepth)
##	f.close()
##
#
#
#
#	pass
#
#
#func _process(delta):
#
#	#reference_kinect.update(0,0,0,0, 500, 300)
#	KinectSensor.reference_kinect.update()
#
#	#img = img.create(512, 424, false, Image.FORMAT_L8)
#
#	var frame_data = KinectSensor.reference_kinect.get_depth_data()
#	print("frame_data.size()")
#	print(frame_data.size())
#	#print(frame_data)
#	#var width = frame_data.get_frame_width()
#	#var height = frame_data.get_frame_height()
#
#
#	#img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
#	#img.save_png("image.png")
#
#	#img = img.create(512, 424, false, Image.FORMAT_R8)
#
##	for y in range(0,424):
##		for x in range(0,512):
###	for y in range(95,275):
###		for x in range(100,420):	
##			#var value = frame_data.decode_s8(x+y*424)*255/2000
##			var value = frame_data.decode_s8(x+y*512)
##			#img.set_pixel(x, y, Color(value,value,value ) ) # Sets the color at (1, 2) to red.
##			img.set_pixel(x, y, value  ) # Sets the color at (1, 2) to red.
##
###
#
#
#
##	for y in range(y_offset,y_length+y_offset):
##		for x in range(x_offset,x_offset+x_length):	
##
##			var value = frame_data.decode_s8( y*512 + x)
##			print(value)
##			processed_frame_data.push_back(value)
##
##	img = img.create_from_data(x_length, y_length, false, Image.FORMAT_R8, processed_frame_data)
#
#	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
#
#
#
#	imgCutten = imgCutten.create(KinectSensor.x_length, KinectSensor.y_length, false, img.get_format())
#	imgCutten.blit_rect(img, Rect2(KinectSensor.x_offset,KinectSensor.y_offset, KinectSensor.x_length, KinectSensor.y_length), Vector2i(0,0))
#
#
#
#
#	#img = reference_kinect.get_depth_image()
#
#
#	print(img.get_size())
#	print(imgCutten.get_size())
#	img.save_png("image.png")
#	imgCutten.save_png("imagecutten.png")
#
#
#	var texture = ImageTexture.create_from_image(imgCutten)
#
##	img_colormap.load("res://4volcono1.png")	
##	var texture_1 = ImageTexture.new()
##	texture_1.create_from_image(img_colormap) #,0
#
#	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)
#
#
#
#
#
#
#
##	for boid in $"../Animals".get_children():
##		boid.img = imgCutten
##		boid.terrain_size = Vector2(KinectSensor.x_length, KinectSensor.y_length)
##
#	img.load("res://4volcono1.png")	
#	$"../one_fish".img = img
#	$"../one_fish".terrain_size = Vector2(512, 424)
#
#	#$"../one_fish".terrain_size = Vector2(KinectSensor.x_length, KinectSensor.y_length)
#

	
	
extends MeshInstance3D


#var reference_kinect

@export var img = Image.new()
var imgCutten = Image.new()
var img_colormap = Image.new()

#@onready var one_fish = $"../one_fish"

#@onready var config_file = 'res://SensorAreaConfig.txt'
#
#
#var x_offset       #探测区域的X轴偏移
#var y_offset       #探测区域的Y轴偏移
#var x_length	   #探测区域的X方向长度
#var y_length	   #探测区域的Y方向长度
#var far_distance    #传感器到沙池底部的最远距离
#var sand_maxdepth   #沙体的最大高度


var processed_frame_data : PackedByteArray 



var StableData  : PackedByteArray
#StableData.resize(KinectSensor.y_length * KinectSensor.x_length)




# Use SimplexNoise if debug enabled, else use GDRealsense
# 如果是DEBUG，采用“开放简单噪声”来生成数据源
#var realsense = FastNoiseLite.new() if (DEBUG) else load("res://bin/x11/gdrealsense.gdns").new()
#var realsense = OpenSimplexNoise.new() if (DEBUG) else load("res://bin/x11/gdrealsense.gdns").new()



#var top_offset = 75
#var right_offset = 50
#var bottom_offset = 40
#var left_offset = 120
#var segment_size = 3





##读取传感器帧数据
#func get_frame():
#	var width : float
#	var height: float
#	var depth_array: PackedByteArray
#
#	#如果是DEBUG，则读取人工生成的数据；如果是运行状态，则从传感器中读取当前深度数据帧
#	if DEBUG:
#		realsense.seed = randi()
#		width = ceil((1280 - right_offset - left_offset)/segment_size) + 1
#		height = ceil((600 - top_offset - bottom_offset)/segment_size) + 1
#		depth_array = realsense.get_image(width, height).get_data()
#	else:
#		depth_array = realsense.get_depth_frame(top_offset, right_offset, bottom_offset, left_offset,segment_size)
#		width = realsense.get_frame_width()
#		height = realsense.get_frame_height()
#		print(width,height)
#	return {"width": width, "height": height, "depth_array": depth_array}

# 初始化：获取传感器帧图像，创建网格模型Called when the node enters the scene tree for the first time.
func _ready():
	
#	print("hello")
#
#	load_config_file(config_file)
#
#	reference_kinect = KinectV2.new()
#	reference_kinect.set_parameter(far_distance, sand_maxdepth)





	
	#processed_frame_data = 
	
#	material = mesh.material
#	rng.randomize()
#
#	#获取帧数据
#	var frame = get_frame()
#
#	#创建帧图像img
#	img = img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)
#	print(frame.width)	
#	print(frame.height)	
#	#print(frame.depth_array)		
#
#	print(img.get_size())
#	#print(img.get_data())
#	#清空初始化表面工具SurfaceTool
#	st.clear()
#	#开始创建三角形
#	st.begin(Mesh.PRIMITIVE_TRIANGLES)
#
#	var vert_x_width = frame.width - 1
#	var vert_y_height = frame.height - 1
#	for y in range(frame.height):
#		for x in range(frame.width):
#			#st.add_smooth_group(true)
#
#			#添加顶点
#			st.add_vertex(Vector3(((8.0*x)/(frame.width)), 0.0, ((4.5 * y)/(frame.height))))
#			# Build indices for a complete mesh
#			var vert_y = y
#			var vert_x = x
#			var next_vert_y = vert_y + 1
#			var next_vert_x = vert_x + 1
#			#将顶点添加到索引数组
#			if(vert_y < vert_y_height and vert_x < vert_x_width):
#				st.add_index((vert_x_width * vert_y) + vert_x)
#				st.add_index((vert_x_width * vert_y) + next_vert_x)
#				st.add_index((vert_x_width * next_vert_y) + next_vert_x)
#
#				st.add_index((vert_x_width * vert_y) + vert_x)
#				st.add_index((vert_x_width * next_vert_y) + next_vert_x)
#				st.add_index((vert_x_width * next_vert_y) + vert_x)
#
#	#设置模型材质
#	st.set_material(material)
#	# 完成模型生成，赋给变量mesh  Commit to a mesh.
#	mesh = st.commit()
#
#	#从模型创建网格数字工具MeshDataTool (MeshDataTool是编辑Mesh数据的工具)
#	mdt.create_from_surface(mesh, 0)


#
#func load_config_file(config_file):
#
#	var f = FileAccess.open(config_file, FileAccess.READ)
#
#	x_offset =  int(f.get_line())
#	y_offset =  int(f.get_line())
#	x_length =  int(f.get_line())
#	y_length =  int(f.get_line())
#	far_distance =  int(f.get_line())
#	sand_maxdepth =  int(f.get_line())
#
#	print(x_offset,y_offset,x_length,y_length,far_distance,sand_maxdepth)
#	f.close()
#
	KinectSensor.reference_kinect.update()
#	var frame_data = KinectSensor.reference_kinect.get_depth_data()
#	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)	
#	imgCutten = imgCutten.create(KinectSensor.x_length, KinectSensor.y_length, false, img.get_format())
#	imgCutten.blit_rect(img, Rect2(KinectSensor.x_offset,KinectSensor.y_offset, KinectSensor.x_length, KinectSensor.y_length), Vector2i(0,0))
#
#

#	var StableData = PackedByteArray()
#	StableData.resize(KinectSensor.y_length * KinectSensor.x_length)
	
	var frame_data = KinectSensor.reference_kinect.get_depth_data()
	for y in range(KinectSensor.y_length):
		for x in range(KinectSensor.x_length):
			var frameX = x + KinectSensor.x_offset
			var frameY = y + KinectSensor.y_offset

			var pixelIndex = frameY * KinectSensor.x_length + frameX
			StableData[y * KinectSensor.x_length + x] = frame_data[pixelIndex]
			
	
	var Distance = 0
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		if StableData[i] > Distance:
			Distance = StableData[i]

	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		if StableData[i] < Distance - 300:
			StableData[i] = Distance - 300
	
	
	
	
	
	
	

			
			
			
			
			

	
	
	
	
	#img.load("res://4volcono1.png")
#	$"../one_fish".img = img
#	$"../one_fish".terrain_size = Vector2(KinectSensor.x_length, KinectSensor.y_length)
	#pass


func _process(delta):

	#reference_kinect.update(0,0,0,0, 500, 300)
	KinectSensor.reference_kinect.update()
	
	#img = img.create(512, 424, false, Image.FORMAT_L8)
	
	var frame_data = KinectSensor.reference_kinect.get_depth_data()
	print("frame_data.size()")
	print(frame_data.size())
	#print(frame_data)
	#var width = frame_data.get_frame_width()
	#var height = frame_data.get_frame_height()


	#img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
	#img.save_png("image.png")

	#img = img.create(512, 424, false, Image.FORMAT_R8)

#	for y in range(0,424):
#		for x in range(0,512):
##	for y in range(95,275):
##		for x in range(100,420):	
#			#var value = frame_data.decode_s8(x+y*424)*255/2000
#			var value = frame_data.decode_s8(x+y*512)
#			#img.set_pixel(x, y, Color(value,value,value ) ) # Sets the color at (1, 2) to red.
#			img.set_pixel(x, y, value  ) # Sets the color at (1, 2) to red.
#
##
	
	
	
#	for y in range(y_offset,y_length+y_offset):
#		for x in range(x_offset,x_offset+x_length):	
#
#			var value = frame_data.decode_s8( y*512 + x)
#			print(value)
#			processed_frame_data.push_back(value)
#
#	img = img.create_from_data(x_length, y_length, false, Image.FORMAT_R8, processed_frame_data)




	frame_data = frame_data.subarray(SandOffY, SandOffY + SandHight, SandOffX, SandOffX + SandWidth)
	frame_data = frame_data.duplicate()
	frame_data.convert_to(TYPE_INT16)

	var indices = frame_data.find_all(self.Distance - SandH, -1)
	for i in indices:
	color_data[i] = self.Distance - SandH

	var dt_data = frame_data - StableData
	var data_p = dt_data.duplicate()
	var data_n = dt_data.duplicate()

	indices = data_p.find_all(self.UpdateDT, -1)
	for i in indices:
	data_p[i] = 0

	indices = data_n.find_all(-self.UpdateDT, -1)
	for i in indices:
	data_n[i] = 0

	indices = data_p.find_all(0, -1)
	for i in indices:
	data_p[i] = 3

	indices = data_n.find_all(0, -1)
	for i in indices:
	data_n[i] = -3

	StableData += data_p
	StableData += data_n
































	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
	
	
	
	imgCutten = imgCutten.create(KinectSensor.x_length, KinectSensor.y_length, false, img.get_format())
	imgCutten.blit_rect(img, Rect2(KinectSensor.x_offset,KinectSensor.y_offset, KinectSensor.x_length, KinectSensor.y_length), Vector2i(0,0))
	
	


	#img = reference_kinect.get_depth_image()
	
	
	print(img.get_size())
	print(imgCutten.get_size())
#	img.save_png("image.png")
	#img.load("res://4volcono1.png")
	#imgCutten.save_png("imagecutten.png")
	
	
	var texture = ImageTexture.create_from_image(imgCutten)

#	img_colormap.load("res://4volcono1.png")	
#	var texture_1 = ImageTexture.new()
#	texture_1.create_from_image(img_colormap) #,0

	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)

	get_surface_override_material(0).set_shader_parameter("contourLineFactor", 10)

	
	
	
	
#	for boid in $"../Animals".get_children():
#		boid.img = imgCutten
#		boid.terrain_size = Vector2(KinectSensor.x_length, KinectSensor.y_length)

#	$"../one_fish".img = imgCutten
#	$"../one_fish".terrain_size = Vector2(KinectSensor.x_length, KinectSensor.y_length)
##
##
#
#
#
	
	
	

	
	
	
##	var frame = get_frame()
##	img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)
##	false # img.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
#
#	#获取当前帧
#	var frame = get_frame()	
#	print(frame.depth_array)
#	#print(frame.depth_array)
#	img = img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)
##	var texture = ImageTexture.new()
##	texture.create_from_image(img) 
#	var texture = ImageTexture.create_from_image(img)
#	img.save_png("image.png")
#
#
#	img_colormap.load("res://graymapforblender.png")	
#	var texture_2 = ImageTexture.new()
#	texture_2.create_from_image(img_colormap) 
#
#
#
#
#
#	img_colormap.load("res://4volcono1.png")	
#	var texture_1 = ImageTexture.new()
#	texture_1.create_from_image(img_colormap) #,0
#
#	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)
##	
##	update_shader(texture,texture_1)
##	#get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)
##
##func update_shader(texture, texture_1):
##
##	#$Terrain.get_surface_override_material(0).set_shader_parameter( "texture_albedo", img )
##
##	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)
##	get_surface_override_material(0).set_shader_parameter("ColorMapSampler", texture_1)
##	#get_surface_material(0)

	var pixelCornerElevationSampler_img = Image.new()


	var imageSize = Vector2(KinectSensor.x_length, KinectSensor.y_length)
	
	
	var newImageData = pixelCornerElevationSampler(imgCutten.get_data(), KinectSensor.x_length, KinectSensor.y_length, Vector2(0.5, 0.5))
	print("newImageData")
	print(newImageData)
	pixelCornerElevationSampler_img.create_from_data(KinectSensor.x_length, KinectSensor.y_length, false, Image.FORMAT_R8, newImageData)	
	var pixelCornerElevationSampler_texture = ImageTexture.create_from_image(pixelCornerElevationSampler_img)
	
	
	get_surface_override_material(0).set_shader_parameter("pixelCornerElevationSampler", pixelCornerElevationSampler_texture)
	
	
	
func pixelCornerElevationSampler(grid: PackedByteArray, width: int, height: int, offset: Vector2):
	print("hello 0 ")
	var topLeftIndex = Vector2()
	var bottomRightIndex = Vector2()
	var topRightIndex = Vector2()
	var bottomLeftIndex = Vector2()
	var newImageData: PackedByteArray
	print("hello 1 ")
	for y in range(0,KinectSensor.y_length):
		for x in range(0,KinectSensor.x_length):	
			
			topLeftIndex.x = floor(offset.x) + x
			topLeftIndex.y = floor(offset.y) + y

			bottomRightIndex.x = ceil(offset.x) + x
			bottomRightIndex.y = ceil(offset.y) + y

			# Check if indices are within bounds
			if topLeftIndex.x < 0 or topLeftIndex.x >= width or topLeftIndex.y < 0 or topLeftIndex.y >= height or  bottomRightIndex.x < 0 or bottomRightIndex.x >= width or bottomRightIndex.y < 0 or bottomRightIndex.y >= height:
				newImageData.append(0)
			else:
				topRightIndex.x = bottomRightIndex.x
				topRightIndex.y = topLeftIndex.y

				bottomLeftIndex.x = topLeftIndex.x
				bottomLeftIndex.y = bottomRightIndex.y

				var topLeftElevation = grid[int(topLeftIndex.y) * width + int(topLeftIndex.x)]
				var topRightElevation = grid[int(topRightIndex.y) * width + int(topRightIndex.x)]
				var bottomLeftElevation = grid[int(bottomLeftIndex.y) * width + int(bottomLeftIndex.x)]
				var bottomRightElevation = grid[int(bottomRightIndex.y) * width + int(bottomRightIndex.x)]

				# Perform bilinear interpolation
				var dx = offset.x + x - floor(offset.x + x)
				var dy = offset.y + y - floor(offset.y + y)
				var topInterpolation = lerp(topLeftElevation, topRightElevation, dx)
				var bottomInterpolation = lerp(bottomLeftElevation, bottomRightElevation, dx)
				var elevation = lerp(topInterpolation, bottomInterpolation, dy)

				#var pixelValue = elevation * 255.0
				var pixelValue = elevation * 1
				newImageData.append(int(pixelValue))
	#            newImageData.append(int(pixelValue))
	#            newImageData.append(int(pixelValue))
	#            newImageData.append(255)  # Alpha channel

	print("hello 2")
	print("newImageData")
	print(newImageData)
	print("hello3")

	return newImageData
