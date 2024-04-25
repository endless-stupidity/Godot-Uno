extends Area2D

func clear_player_hand() -> void:
	for child in get_children():
		child.queue_free()
