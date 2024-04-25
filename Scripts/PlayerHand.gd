extends Area2D

func clear_player_hand() -> void:
	for child in get_children():
		child.queue_free()

func update_player_hand() -> void:
	clear_player_hand()
	var card_count = GameMaster.player_hand.size()
	var area_size = $PlayerHandArea.shape.get_rect().size
	var spacing = area_size.x / (card_count + 1)
	var position_x = spacing
	
	for card in GameMaster.player_hand:
		card.position = Vector2(position_x, area_size.y / 2) 
		add_child(card)
		position_x += spacing
