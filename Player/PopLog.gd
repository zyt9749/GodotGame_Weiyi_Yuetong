extends NinePatchRect


onready var refRect1 = $RefRect1


# Called when the node enters the scene tree for the first time.
func _ready():
#	self.hide()
	refRect1.set_position(Vector2(7,7))
	var ref_size = self.get_size()-Vector2(14,10)
	refRect1.set_size(ref_size)
