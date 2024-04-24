extends Node2D

func _ready() -> void:
	GameMaster.init_deck()
	var drawn_cards = GameMaster.draw_from_deck(3)
	for card in drawn_cards:
		add_child(card)
