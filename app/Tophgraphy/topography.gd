extends Node3D
var st = SurfaceTool.new()

var mdt = MeshDataTool.new()

const DEBUG = true
var realsense = FastNoiseLite.new() 

var img = Image.new()
var top_offset = 75
var right_offset = 50
var bottom_offset = 40
var left_offset = 120
var segment_size = 3
var sea_level = 0.02
var material
var terr 

func get_frame():
	var width : float
	var height: float
	var depth_array: PackedByteArray
	
	#如果是DEBUG，则读取人工生成的数据；如果是运行状态，则从传感器中读取当前深度数据帧
	if DEBUG:
		realsense.seed = randi()
		width = ceil((1280 - right_offset - left_offset)/segment_size) + 1
		height = ceil((600 - top_offset - bottom_offset)/segment_size) + 1
		depth_array = realsense.get_image(width, height).get_data()
	else:
		depth_array = realsense.get_depth_frame(top_offset, right_offset, bottom_offset, left_offset,segment_size)
		width = realsense.get_frame_width()
		height = realsense.get_frame_height()
		
	return {"width": width, "height": height, "depth_array": depth_array}



# Called when the node enters the scene tree for the first time.
func _ready():

	terr = get_node("Terrain")
	material = terr.mesh.material
	var frame = get_frame()

	#创建帧图像img
	img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)

#
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
#	terr.mesh = st.commit()
#
#	#从模型创建网格数字工具MeshDataTool (MeshDataTool是编辑Mesh数据的工具)
#	mdt.create_from_surface(terr.mesh, 0)


#func update_terrain(_height_ratio, _colshape_size_ratio):
#	material_override.set("shader_param/height_ratio", _height_ratio)
#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#获取当前帧
	var frame = get_frame()
	#创建图像
	img.create_from_data(frame.width, frame.height, false, Image.FORMAT_R8, frame.depth_array)
	
	
	var height_map = ImageTexture.new()
	height_map.create_from_image(img)
	
	
	print(height_map)

	terr.mesh.material.set_shader_parameter('heightmap', height_map)
	#terr.mesh.material.set_shader_parameter('_a', height_map)
	terr.mesh.material.set_shader_parameter('height_ratio', 0.02)
	print("更新")
#	material_override.set("shader_param/height_ratio", 20.0)
#	material_override.set("shader_param/height_ratio", img)
