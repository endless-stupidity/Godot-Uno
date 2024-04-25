extends Area2D

func clear_player_hand() -> void:
	for child in get_children():
		child.queue_free()

func update_player_hand() -> void:
	clear_player_hand()
	for card in GameMaster.player_hand:
		add_child(card)
