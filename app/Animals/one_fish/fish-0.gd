#@tool

extends Node3D


#var pos: Transform3D  #鱼的3D变换
#var num: int		#鱼的编号
#var speed : float  #鱼的速度
#var velocity : Vector3  #鱼的速度向量
#var custom_data: Color  #鱼的颜色
#

var old_transform 
var new_transform 

var fish_translate = Vector3()

var acrossBorder = 0

# Boid's x, y origin
var old_velocity = Vector3(0,0,0)
var velocity = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)

var randomValues_X = [randf(), randf(), randf(), randf()]
var randomValues_Y = [randf(), randf(), randf(), randf()]
var randomValues_Z = [randf(), randf(), randf(), randf()]

var cumWavLen = Vector3(0,0,0)

var ownTime = 0

var rorateSign = 0

func initBoid(window_width, window_height, movement_depth):
	var x = randf_range(-window_width, window_width)
	var y = randf_range(-window_height, window_height)
	var z = randf_range(-movement_depth, movement_depth)
	var d = 1
	#设置鱼的初始位置
	position = Vector3(x,y,z)
	#设置鱼的初始速度与方向（velocity中含有方向和速度，方向是velocity.normalized , 速度是velocity.length)
	velocity = Vector3(randf_range(0, d), 0, randf_range(0, d))	
	#return self

	var angle : float = Vector3(0,0,-1).angle_to(velocity)
	var axis : Vector3 = Vector3(0,0,-1).cross(velocity).normalized()
	if axis.is_normalized():
		transform.basis = transform.basis.rotated(axis, angle)
	
	
	
	
	
# 张珣新加	
#var img = Image.new()
#var img_colormap = Image.new()

var pixel

# 存储像素值等于0的数组
var filtered_vectors = []

var target_position   # 目标位置
var move_duration = 0.1  # 移动持续时间
var current_time = 0.0  # 当前时间
var start_position: Vector3  # 起始位置

var index
var get_index = true	
	
#@export_global_file("*.png") var greymap_image
#@export var greymap_image : Image
@export var img : Image = Image.new()
@export var terrain_size : Vector2


func _ready():
	#img.load(greymap_image)
	#img = greymap_image

	_on_move_complete()	
	
	
func _process(delta):
	
#	#img.load(greymap_image)
#	#img = greymap_image
#	# 移动的逻辑 ，利用线性插值进行移送，或者利用动画进行移动
#	current_time += delta
#	if current_time > move_duration:
#		current_time = move_duration
#
#	var t = current_time / move_duration  # 计算插值系数
#
#	self.position = start_position.lerp(target_position, t)  # 进行线性插值
#
#
#
#	if current_time >= move_duration:
#		_on_move_complete()
	pass

func _on_move_complete():
	# 移动完成后的逻辑
	current_time = 0.0  # 当前时间
	start_position = self.position # 更新起始位置
	
	print("start_position",start_position)
	
	var thing_pixel_coord = coordinates_space2pixel(start_position)

	var radius = 2
	get_area(thing_pixel_coord,radius,filtered_vectors)
	# 在周围的像素点中取另一个像素点，将其转为空间坐标，然后让物体向这个坐标移动
#	var random_index = randi() % filtered_vectors.size()
#	var random_value = filtered_vectors[random_index]
	if get_index:
		if filtered_vectors.size() > 0 :
			index = randi() % filtered_vectors.size()
			get_index = false
		
	if filtered_vectors.size() < pow(radius*2+1,2) /2:
		get_index = true
		
	var pixel_position = filtered_vectors[index]
	
	filtered_vectors.clear()
	
	# 将选择的中间像素坐标映射到空间坐标 ,
	var temp_position = coordinates_pixel2space(pixel_position)
	target_position = temp_position + Vector3(0,start_position.y,0)
	self.look_at(Vector3(target_position.x,3,target_position.z ))
#	target_position.x += randi() % 2 + randf()
#	target_position.z += randi() % 2 + randf()
	
	print("target_position",target_position)
	
# 将移动物体的空间坐标
func coordinates_space2pixel(space_coord: Vector3)->Vector2:
	# 图片的大小
	var img_size = img.get_size()
	# 地形的大小
	print(img_size)
	
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
	#var terrain_size = terrain_node.mesh.size
	
	var pixel_space_x =   pixel_coord.x  *(terrain_size.x / img_size.x )
	var pixel_space_y =   pixel_coord.y  *(terrain_size.y / img_size.y )
	
	return Vector3(pixel_space_x,0,pixel_space_y)


# 图片上以A点为中心，获取在半径radiu范围的所有像素值
func get_area(pos:Vector2,radius:int,filtered_vectors:Array):
	var i = 0
	for y in range(pos.y - radius, pos.y + radius + 1):
		for x in range(pos.x - radius, pos.x + radius + 1):
			if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
				pixel = img.get_pixel(x ,y)
				var vector = Vector2(x, y)
				if pixel.r < 50:
					filtered_vectors.append(vector)

	
	
	
	
	
	
	
	
	
	
	
	
	
#
#
#func _ready():  # ready state or initial state
#	trailRef = get_node(trail)
#	modulate = targetColor
#	velocity = Vector2(0,0) #sets velocity so that in begaing the flock don't move
#	#velocity = Vector2(rand_range(-maxVelocity, maxVelocity),rand_range(-maxVelocity, maxVelocity)) # Use if you want to flock get movemnt autometically at begaining
#
#
#
#func _process(delta): #the main function
#	velocity += acceleration.clamped(maxAcceleration * delta) #used to increase the velocity slowly to the maximum
#	velocity = velocity.clamped(maxVelocity)
#	acceleration.x = 0 #sets acceleration so that in begaing the flock don't move
#	acceleration.y = 0 #sets acceleration so that in begaing the flock don't move
#
#	position += velocity * delta # Increases positions value which makes the flocks move
#
#	look_at(position + velocity) # flocks heading
#	rotation += rotationOffset #flocks rotation
#
#	var targetColorPercent = delta * colorTransitionSpeed
#	modulate = modulate * (1 - targetColorPercent) + targetColor * targetColorPercent #for colour changing 
#
#
#func update(delta):
#	var avoid_dir : Vector3 = get_avoid_direction_or_forward()
#	var obstacle_avoid_force : Vector3 = obstacle_avoid_weight * steer_towards(avoid_dir)
#	var attention_force : Vector3 = attention_weight * steer_towards(attention_heading)
#
#	acceleration += obstacle_avoid_force
#	acceleration += attention_force
#
#	if flock_count > 0:
#		var cohesion_force : Vector3 = cohesion_weight * steer_towards(flock_centre - translation)
#		var align_force : Vector3 = align_weight * steer_towards(flock_direction)
#		var separation_force : Vector3 = separation_weight * steer_towards(separation_heading)
#		acceleration += cohesion_force
#		acceleration += align_force
#		acceleration += separation_force
#
#	# Integrate forces
#	var old_velocity : Vector3 = velocity
#	velocity += delta * acceleration
#
#	direction = velocity.normalized()
#	var speed : float = velocity.length()
#
#	speed = clamp(speed, min_speed, max_speed)
#	velocity = direction * speed
#
#	translation += delta * velocity
#
#	# Rotate the fish around an axis perpendicular to the velocity change	
#	var angle : float = old_velocity.angle_to(velocity)
#	var axis : Vector3 = old_velocity.cross(velocity).normalized()
#	if axis.is_normalized():
#		global_transform.basis = global_transform.basis.rotated(axis, angle)
#
#func steer_towards(dir : Vector3) -> Vector3:
#	return max_speed * dir.normalized() - velocity
#
#
## Returns opposite direction of the first ray that hits an obstacle or the forward
## direction if no ray collided (both in global space)
#func get_avoid_direction_or_forward() -> Vector3:
#	# Check if near the water surface
#	if translation.length() > 1.0 - ray_length:
#		return -translation.normalized()
#
#	# Check for obstacles
#	var directions : PoolVector3Array = BoidHelper.directions
#	for d in directions:
#		var res = cast_ray(d)
#		if res:
#			return -d
#	return global_transform.basis.x
#
#
#
#
#
#
#

