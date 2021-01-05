extends Area2D


var target = null

func can_interact():
	return target != null


func _on_InteractionDetectionZone_body_entered(_body):
	target = _body

func _on_InteractionDetectionZone_body_exited(_body):
	target = null

