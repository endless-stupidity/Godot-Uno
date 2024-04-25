extends Node2D

@onready var player_hand = $PlayerHand

func _ready() -> void:
	GameMaster.init_deck()
	GameMaster.draw_to_player_hand(3)
	player_hand.update_player_hand()
