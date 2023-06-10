@tool
extends MeshInstance3D
var timer = 0
func _process(delta):
	timer += delta
	get_surface_override_material(0).set_shader_parameter( "fish_timer", timer )
	#get_surface_material(0).set_shader_param( "timer", timer )
#	update_shader()
	#print(timer)
	
func _ready():
	#update_shader()
	set_process(true)
	pass
