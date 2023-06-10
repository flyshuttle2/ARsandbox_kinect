extends Node3D

#@onready var boid_scene = preload("res://Scenes/Farm/boid_fish.tscn")
@onready var boid_carp= preload("res://Animals/one_fish/single_fish.tscn")


##鱼池大小：长28M*高1.2M*宽1.2M
#@export var window_width = 10.0     #X轴
#@export var window_height = 0.6     #Y轴 纵向
#@export var forward_depth = 3.4     #Z轴
#@export var z_offset = 0.0
#@export var window_depth = 2.4     #Z轴



@export var numBoids : int = 10 # Number of boids spawned at the start (int, 0, 1000) (it should be adjustable dynamically).


#分离(避开）行为参数
#分离行为半径1m,1m之外看不见
@export var avoidNeighborDistance :float = 0.30
#分离行为权重Weight for AvoidOthers(seperate) behaviour
@export var avoidOthersFactor : float = 0.25 

#对齐行为参数
#分离行为半径1m,1m之外看不见
@export var alineNeighborDistance :float = 1.0 
#分离行为权重Weight for AvoidOthers(seperate) behaviour
@export var alineFactor : float = 0.05 

#凝聚行为参数
#凝聚行为半径5m,5m之外看不见
@export var cohesionNeighborDistance : float = 2.0
#凝聚行为权重 Weight for flyTowardsCenter behaviour.
@export var cohesionFactor : = 0.02

#越界行为权重
@export var boundFactor : = 0.025

#随机转向权重
@export var steerRandomFactor : = 0.09

#规则的总系数
@export var ruleScalar : = 0.5

@export var maxSpeed : = 0.5

#20m*1.2M*4.8M 长高宽
@export var tankSize : Vector3 = Vector3(20,0.6,3.4)

@export var maxBound : Vector3 = Vector3(7.8,0.6,4.3)
@export var minBound : Vector3 = Vector3(0.2,0,0.2)


var randomWavelenScalar = 0.6

#运动速度的控制
@export var playSpeed : = 4

#随机运动标识
@export var randomSign : = true

var boids = []
var goalPos = Vector3.ZERO




var x_lower = 0
var x_upper = 8
var y_lower = 0
var y_upper = 0.8
var z_lower = 0
var z_upper = 4.5

#鱼活动的边界 x起点的X坐标，y起点的Y坐标，z值保存X轴方向上的宽度，w值保存Y轴方向上的宽度
var borders : Vector4 = Vector4(0, 0 , 8, 4.5)
@export var terrain_size := Vector2(8,4.5)

var border_coef = 0.95
var internalBorders : Vector4 = border_coef * borders


var topSpeed : = 0.1
var maxVelocityChange : = 0.1

var water_depth = 0.5  #水深系数，这个变量用于判断鱼或者船是否在水里

#var globalVelocityChange : Vector3 = Vector3(0,0,0)

#var terrain_mesh = $"../Terrain".mesh
#var width = terrain_mesh.


func _ready():


	#add_child(mouse_sphere_kinematicbody)
	for i in range(numBoids):
		var new_boid = boid_carp.instantiate()
		add_child(new_boid) # This needs to be done first because boids call get_parent on initBoid()
		new_boid.initBoid(x_lower+0.2,x_upper-0.2,y_lower,y_upper,z_lower+0.2,z_upper-0.2)	
#		boids.push_back(new_boid.initBoid(x_lower+0.2,x_upper-0.2,y_lower,y_upper,z_lower+0.2,z_upper-0.2))
#		new_boid.position = Vector3(new_boid.x, new_boid.y, new_boid.z)
		print(new_boid.position)
		print(new_boid.velocity)




func _process(delta):
	var playDelta = playSpeed * delta * 100
	#print(playDelta)
	#if (playDelta > 1000) : playDelta = 30


#	if randf_range(1,50000) < 50 :
#		goalPos = Vector3(randf_range(-window_width, window_width),
#			randf_range(-window_height, window_height),
#			randf_range(-window_depth, window_depth))


	#for boid in boids:
	for boid in get_children():
		print("boid.position")
		print(boid.position)



		boid.ownTime += playDelta * 0.0002
		#print(boid.ownTime)


		#var boidPosition = Vector3(boid.x, boid.y, boid.z)

		#print("boidPosition")
		#print(boidPosition)

		if randf_range(0,1) < 1 :   
			ApplyRules(boid,delta)     #求得并返回 新的方向和速度（一个向量，长度是速度，方向是3个值）

		print(boid.globalVelocityChange)

		update(boid,delta)     #求得并返回 新的方向和速度（一个向量，长度是速度，方向是3个值）

#		boid.x += boid.velocity.x
#		boid.y += boid.velocity.y
#		boid.z += boid.velocity.z
#
		if boid.velocity.cross(Vector3.UP) != null:
#			var new_transform= boid.transform.basis.looking_at(boid.velocity, Vector3.UP)
#			boid.transform = boid.transform.interpolate_with(new_transform, 10 * delta)
			boid.transform.basis = transform.basis.looking_at(boid.velocity,Vector3.UP)

#
#		boid.transform.origin = boidPosition + boid.velocity 








	pass





func ApplyRules(boid , delta):
#	#五个向量和：避开、对齐、加入、掉头转回、随机转向
#	var avoid = Vector3(0,0,0)
#	var aline = Vector3(0,0,0)
#	var joinin = Vector3(0,0,0)
#	var steerback = Vector3(0,0,0)
#	var steerRandom = Vector3(0,0,0)
#
#	var totalAcceleration = Vector3(0,0,0)
#	var newVelocity = Vector3(0,0,0)
#	var newVelocity_clone = Vector3(0,0,0)
#
#	var boidPosition = Vector3(boid.x, boid.y, boid.z)
#	var difference = Vector3(0,0,0)
#	var distance = 0.0
#	#计算分离转向向量
#	for otherBoid in boids:
#		if boid != otherBoid:
#			var otherBoidPosition = Vector3(otherBoid.x, otherBoid.y, otherBoid.z)
#
#
#			difference = boidPosition - otherBoidPosition
#			distance = boidPosition.distance_to(otherBoidPosition)
#			#print("distance")
#			#print(distance)
#			if(distance < avoidNeighborDistance and distance >0.0):
#				avoid += difference.normalized() * (1- distance/avoidNeighborDistance)
#			if(distance < alineNeighborDistance  and distance >0.0):
#				aline += otherBoid.velocity.normalized() * (1- distance/alineNeighborDistance)
#			if(distance < cohesionNeighborDistance  and distance >0.0):
#				joinin += -difference.normalized() * (1- distance/cohesionNeighborDistance)
#
##	avoid = avoid/avoid.length()
##	aline = aline/aline.length()
##	joinin = joinin/joinin.length()
#
#	avoid = avoid.limit_length(1)
#	aline = aline.limit_length(1)
#	joinin = joinin.limit_length(1)
#
#	totalAcceleration = avoid * avoidOthersFactor + aline * alineFactor * 0.4 + joinin * cohesionFactor 
#
#
#	#游出边界处理
#	if (boidPosition.x >= maxBound.x) : steerback.x = maxBound.x - boidPosition.x
#	elif  (boidPosition.x <= minBound.x) : steerback.x = minBound.x - boidPosition.x
#	if (boidPosition.y >= maxBound.y) :  steerback.y = maxBound.y - boidPosition.y
#	elif  (boidPosition.y <= minBound.y) :steerback.y = (minBound.y - boidPosition.y)*2  #从地底下快速上来
#	if (boidPosition.z >= maxBound.z) : steerback.z = maxBound.z - boidPosition.z
#	elif  (boidPosition.z <= minBound.z) : steerback.z = minBound.z - boidPosition.z
#	#print(steerback)
#
#	if steerback != Vector3(0, 0, 0) :
#		totalAcceleration += steerback * boundFactor
#
#
#	#增加随机性
#	if randomSign :
#		var wavelen = 0.3;
#		var time = boid.ownTime * randomWavelenScalar;
#
#		var time_x = time
#		var time_y = time + 0.1
#		var time_z = time + 0.2
#
#		if (time_x >= boid.cumWavLen.x) :
#			boid.cumWavLen.x += wavelen
#			#boid.randomValues_X.remove_at(0)
#			boid.randomValues_X.pop_front()
#			boid.randomValues_X.push_back(randf())
#
#		if (time_y >= boid.cumWavLen.y) :
#			boid.cumWavLen.y += wavelen
#			boid.randomValues_Y.pop_front()
#			boid.randomValues_Y.push_back(randf())
#
#		if (time_z >= boid.cumWavLen.z) :
#			boid.cumWavLen.z += wavelen
#			boid.randomValues_Z.pop_front()
#			boid.randomValues_Z.push_back(randf())
#
#		steerRandom.x = cubicInterpolate(boid.randomValues_X, fmod(time_x , wavelen) / wavelen ) *2 - 1
#		steerRandom.y = (cubicInterpolate(boid.randomValues_Y, fmod(time_y, wavelen) / wavelen ) *2 - 1 )* 0.2
#		steerRandom.z = cubicInterpolate(boid.randomValues_Z, fmod(time_z, wavelen) / wavelen ) *2 - 1
#
#		if steerRandom != Vector3(0, 0, 0) :
#			totalAcceleration += steerRandom * steerRandomFactor
#
#
#
#
#
#
#	#总加速度
#	#print(totalAcceleration)
#	totalAcceleration = totalAcceleration * delta * ruleScalar *100
#	#print(totalAcceleration)
#
#	#totalAcceleration.y *= 0.8
#	totalAcceleration.y *= 0.0
#
#	newVelocity = boid.velocity
#	newVelocity += totalAcceleration
#	#newVelocity_clone = newVelocity.limit_length(maxSpeed)
#	newVelocity_clone = newVelocity
#	newVelocity_clone = newVelocity_clone * delta * 20
#	newVelocity_clone = newVelocity_clone * delta 	* 5
#	boid.velocity = newVelocity_clone
#	boid.velocity = Vector3(newVelocity_clone.x, 0 , newVelocity_clone.z)
#
#
#
#
##	#更新位置
##	#boid.position = Vector3(boid.x, boid.y, boid.z) + newVelocity_clone
##	boid.position = boidPosition + newVelocity_clone 
##	print(newVelocity_clone)
##	print(boid.position)
##
##
##
##
##	#更新方向
##	boid.look_at(boid.position, Vector3.UP)      #  转向目标，以纵轴旋转
#
##		var up_vector = base.basis * Vector3.UP
##		var base = boids_multi_mesh.multimesh.get_instance_transform(i)
##			base.basis = base.basis.looking_at(



	boid.bordersF = bordersEffect(boid, delta)
	boid.waterF = water_effect(boid, delta)
	
	if boid.border :
		boid.applyVelocityChange(boid.bordersF)
	boid.applyVelocityChange(boid.waterF)
#
#
#
#func applyVelocityChange(velocityChange):
#	globalVelocityChange += velocityChange



func update(boid, delta):
	boid.velocity += boid.globalVelocityChange
	if  boid.velocity.length() > topSpeed : 
		boid.velocity = topSpeed * boid.velocity.normalized()
		print("too fast")
	print("boid.velocity")
	print(boid.velocity)
	#boid.transform.origin += boid.velocity
	boid.position += boid.velocity *delta*2
	print("boid.position")
	print(boid.position)
	
	boid.globalVelocityChange *= 0
		
#	if boid.velocity.cross(Vector3.UP) != null:
#		var new_transform= boid.transform.basis.looking_at(boid.velocity, Vector3.UP)
#		boid.transform = boid.transform.interpolate_with(new_transform, 10 * delta)









# 立方插值 cubic interpolation using Paul Breeuwsma coefficients
func cubicInterpolate(values, x) :
	var x2 = x * x
	var a0 = -0.5 * values[0] + 1.5 * values[1] - 1.5 * values[2] + 0.5 * values[3]
	var a1 = values[0] - 2.5 * values[1] + 2 * values[2] - 0.5 * values[3]
	var a2 = -0.5 * values[0] + 0.5 * values[2]
	var a3 = values[1]
	return a0 * x * x2 + a1 * x2 + a2 * x + a3






#判断一个三维的点，是否落在一个平面的矩形框内 
##鱼活动的边界Borders是一个四元向量: x是起点的X坐标，y是起点的Y坐标，z值保存X轴方向上的宽度，w值保存Y轴方向上的宽度
func inside(Borders , location):
	if (Borders.x <= location.x and location.x<= Borders.x + Borders.z) and (Borders.y <= location.z and location.z <= Borders.y + Borders.w):
		return true
	else:
		return false
		
	





func bordersEffect(boid , delta):
	var desired : Vector3
	var futureLocation : Vector3
	var location : Vector3
	var velocity : Vector3    
	var velocityChange : Vector3 
	
	location = boid.position
	velocity = boid.velocity
	
	#Predict location 10 (arbitrary choice) frames ahead
	futureLocation = location + velocity*10;
	
	#目标位置
	var target = location
	
	#如果鱼超出了范围，
	if (!inside(internalBorders, futureLocation)): #Go to the opposite direction
		boid.border = true
		if (futureLocation.x < internalBorders.x):
			target.x = borders.x + borders.z
		if (futureLocation.z < internalBorders.y):
			target.z = borders.y + borders.w
		if (futureLocation.x > internalBorders.x + internalBorders.z):
			target.x = borders.x
		if (futureLocation.z > internalBorders.y + internalBorders.w):
			target.z = borders.y
	else :
		boid.border = false

	
	desired = target - location
	desired.normalized()
	desired *= topSpeed
	
	
	velocityChange = desired - velocity;
	if 	velocityChange.length() > maxVelocityChange: velocityChange = maxVelocityChange * velocityChange.normalized()
	return velocityChange



func water_effect(boid , delta):
	var desired : Vector3
	var futureLocation : Vector3
	var location : Vector3
	var velocity : Vector3    
	var velocityChange : Vector3 

	location = boid.position
	velocity = boid.velocity

	#Predict location 10 (arbitrary choice) frames ahead
	futureLocation = location + velocity*10;

	#目标位置
	var target = location

	#下一个移动点是否在水中
	# 不在，更新移动方向
	if (!is_pos_in_water(futureLocation)): #Go to the opposite direction
		boid.border = true
	if (futureLocation.x < internalBorders.x):
		target.x = borders.x + borders.z
	if (futureLocation.z < internalBorders.y):
		target.z = borders.y + borders.w
	if (futureLocation.x > internalBorders.x + internalBorders.z):
		target.x = borders.x
	if (futureLocation.z > internalBorders.y + internalBorders.w):
		target.z = borders.y
	else :
		boid.border = false


	desired = target - location
	desired.normalized()
	desired *= topSpeed


	velocityChange = desired - velocity;
	if  velocityChange.length() > maxVelocityChange: velocityChange = maxVelocityChange * velocityChange.normalized()
	return velocityChange




# 这个点是否在水中
func is_pos_in_water(pos):
	# var location : Vector3 = boid.position
	var pos_pixel = coordinates_space2pixel(pos,Vector2(KinectSensor.x_length, KinectSensor.y_length),terrain_size)
	var pixel = $"../Terrain".img.get_pixel(pos_pixel.x ,pos_pixel.y)
	if pixel.r > water_depth:
		return false
	return true

func coordinates_space2pixel(space_coord: Vector3,img_size,terrain_size)->Vector2:
	# 图片的大小
	# var img_size = img.get_size()
	# 图片像素坐标和物体坐标之间的映射,
	var pixel_coord_x =  space_coord.x * (img_size.x / terrain_size.x)
	var pixel_coord_y =  space_coord.z * (img_size.y / terrain_size.y)

	# int()：将浮点数舍入到最接近的整数。
	return Vector2(int(pixel_coord_x),int(pixel_coord_y))

 


