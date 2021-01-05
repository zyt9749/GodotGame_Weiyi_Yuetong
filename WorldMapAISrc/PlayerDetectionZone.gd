extends Area2D

var player = null

func can_see_player():
	return player != null


#func _on_PlayerDetectionZone_body_shape_entered(_body_id, body, _body_shape, _area_shape):
#	player = body
#
#
#func _on_PlayerDetectionZone_body_shape_exited(_body_id, _body, _body_shape, _area_shape):
#	player = null


func _on_PlayerDetectionZone_body_entered(_body):
	player = _body


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
