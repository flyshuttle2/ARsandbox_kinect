extends AnimationPlayer
#var animation = AnimationResource.new()
#var getAnimation = animation.getAnimationResource()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play("Armature|鱼_游泳")
