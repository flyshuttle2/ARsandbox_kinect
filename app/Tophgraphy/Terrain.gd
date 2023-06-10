extends MeshInstance3D

#@onready var height_ratio = 20
@onready var chunk_size = 2.0

#碰撞体网格数量（相对原地形网格）的比率
@onready var colshape_size_ratio = 0.1

#@onready var colshape = $StaticBody3d/CollionShape3d










# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_terrain(_height_ratio, _colshape_size_ratio):
	material_override.set("shader_param/height_ratio", _height_ratio)
	material_override.set("shader_param/height_ratio", _height_ratio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.








