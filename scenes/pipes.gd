extends Area2D


signal score_point


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()


func _on_score_area_body_entered(body: Node2D) -> void:
	if body is Player:
		score_point.emit()
