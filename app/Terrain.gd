
extends MeshInstance3D

var SandOffX = KinectSensor.x_offset
var SandOffY = KinectSensor.y_offset
var SandHight = KinectSensor.y_length
var SandWidth = KinectSensor.x_length

@export var img = Image.new()
var imgCutten = Image.new()
var img_colormap = Image.new()

#var StableData  : PackedByteArray  
#
#var processed_frame_data : PackedByteArray 

 
var StableData  : PackedInt32Array  
var processed_frame_data : PackedInt32Array 


var DEPTH_NORMALIZE = 2000 / 255

var UpdateDT =  10.0           #帧更新的高度变化量（单位毫米），在这个变化量之内，视做误差抖动，不做更新。
var SandH = 300  #沙体的预设最大高度 mm

func _ready():

	KinectSensor.reference_kinect.update()
#	var frame_data = KinectSensor.reference_kinect.get_depth_data()
#	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)	
#	imgCutten = imgCutten.create(KinectSensor.x_length, KinectSensor.y_length, false, img.get_format())
#	imgCutten.blit_rect(img, Rect2(KinectSensor.x_offset,KinectSensor.y_offset, KinectSensor.x_length, KinectSensor.y_length), Vector2i(0,0))
#
#

#	var StableData = PackedByteArray()
#	StableData.resize(KinectSensor.y_length * KinectSensor.x_length)
	
	# frame_data 是 原始高度经过 处理后在0~255区间的值，处理的方式是 高度值 * 255 / 2000 .
	var frame_data = KinectSensor.reference_kinect.get_depth_data()
	for y in range(KinectSensor.y_length):
		for x in range(KinectSensor.x_length):
			var frameX = x + KinectSensor.x_offset
			var frameY = y + KinectSensor.y_offset

			var pixelIndex = frameY * KinectSensor.x_length + frameX
			print(frameY)
			print(KinectSensor.x_length)
			print(frameX)
			print("pixel  Index", pixelIndex)

			print("frame_data[pixelIndex]  ", frame_data[pixelIndex])			
			StableData[y * KinectSensor.x_length + x] = frame_data[pixelIndex]  #* 2000 / 255
			
	#找到最远的距离值
	var Distance = 0
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		if StableData[i] > Distance:
			Distance = StableData[i]
	
	print("Distance", Distance)
	
	#在沙体最高处上方的值，将其过滤掉，让其值就等于沙体最高点的数据
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		if StableData[i]  < Distance - SandH:
			#StableData[i] = (Distance * DEPTH_NORMALIZE- 300) * 255 / (Distance * DEPTH_NORMALIZE)
			StableData[i] = Distance - SandH
	
	


func _process(delta):

	KinectSensor.reference_kinect.update()
	
	var frame_data = KinectSensor.reference_kinect.get_depth_data()
	print("frame_data.size()")
	print(frame_data.size())

	#只取有效范围内的值
	for y in range(KinectSensor.y_length):
		for x in range(KinectSensor.x_length):
			var frameX = x + KinectSensor.x_offset
			var frameY = y + KinectSensor.y_offset

			var pixelIndex = frameY * KinectSensor.x_length + frameX
			processed_frame_data[y * KinectSensor.x_length + x] = frame_data[pixelIndex]



	var Distance = 0    # 最远距离对应到255之后的值 （以2000mm为基准）
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		if processed_frame_data[i] > Distance:
			Distance = processed_frame_data[i]
	
	#在沙体最高处上方的值，将其过滤掉，让其值就等于沙体最高点的数据
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
#		if processed_frame_data[i] * DEPTH_NORMALIZE < Distance * DEPTH_NORMALIZE- 300:
#			processed_frame_data[i] = (Distance * DEPTH_NORMALIZE- 300) * 255 / (Distance * DEPTH_NORMALIZE)
		if processed_frame_data[i]  < Distance - SandH:
			processed_frame_data[i] = Distance - SandH
		
	# 将两帧的数值相减 获得差值数组
	#var dt_data = processed_frame_data - StableData
	var dt_data
	for i in range(KinectSensor.y_length * KinectSensor.x_length):
		dt_data[i] = processed_frame_data[i] - StableData[i] 

	
	var data_p = dt_data.duplicate()
	var data_n = dt_data.duplicate()

	#如果两帧的高度值变化不大，视为噪点，不做考虑，变化量取值为0
	for i in range(data_p.size()):
		if data_p[i] <= UpdateDT:
			data_p[i] = 0

	for i in range(data_n.size()):
		if data_n[i]  >= -UpdateDT:
			data_n[i] = 0

	#对于其他有更大变化的点，将其变化值设置为3mm。（相当于让它缓慢更新，一次只更新3mm？）
	for i in range(data_p.size()):
		if data_p[i] != 0:
			data_p[i] = 3 

	for i in range(data_n.size()):
		if data_n[i] != 0:
			data_n[i] = - 3


	StableData += data_p
	StableData += data_n


	var StableData_temp = StableData.duplicate()
	StableData_temp /= Distance
	StableData_temp *= 255.0

	var minfloat = (Distance - SandH) / Distance
	minfloat *= 255.0

	StableData_temp = (1.0 / (255.0 - minfloat)) * (255.0 - StableData_temp) * 255.0

	StableData_temp.invert_y()


	#img = img.create_from_data(512, 424, false, Image.FORMAT_R8, frame_data)
	img = img.create_from_data(512, 424, false, Image.FORMAT_R8, StableData_temp)
	

#	imgCutten = imgCutten.create(KinectSensor.x_length, KinectSensor.y_length, false, img.get_format())
#	imgCutten.blit_rect(img, Rect2(KinectSensor.x_offset,KinectSensor.y_offset, KinectSensor.x_length, KinectSensor.y_length), Vector2i(0,0))

	
	print(img.get_size())
	#print(imgCutten.get_size())
#	img.save_png("image.png")
	#img.load("res://4volcono1.png")
	#imgCutten.save_png("imagecutten.png")
	
	
	#var texture = ImageTexture.create_from_image(imgCutten)
	var texture = ImageTexture.create_from_image(img)
	
#	img_colormap.load("res://4volcono1.png")	
#	var texture_1 = ImageTexture.new()
#	texture_1.create_from_image(img_colormap) #,0

	get_surface_override_material(0).set_shader_parameter("texture_albedo", texture)

	get_surface_override_material(0).set_shader_parameter("contourLineFactor", 10)

	

#
#	var pixelCornerElevationSampler_img = Image.new()
#
#
#	#var imageSize = Vector2(KinectSensor.x_length, KinectSensor.y_length)
#
#
#	var newImageData = pixelCornerElevationSampler(StableData_temp, KinectSensor.x_length, KinectSensor.y_length, Vector2(0.5, 0.5))
#	print("newImageData")
#	print(newImageData)
#	pixelCornerElevationSampler_img.create_from_data(KinectSensor.x_length, KinectSensor.y_length, false, Image.FORMAT_R8, newImageData)	
#	var pixelCornerElevationSampler_texture = ImageTexture.create_from_image(pixelCornerElevationSampler_img)
#
#
#	get_surface_override_material(0).set_shader_parameter("pixelCornerElevationSampler", pixelCornerElevationSampler_texture)
#
	
	
func pixelCornerElevationSampler(grid: PackedInt32Array, width: int, height: int, offset: Vector2):
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
