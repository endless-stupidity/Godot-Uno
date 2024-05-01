extends Node2D

@onready var player_hand = $PlayerHand
@onready var discard_pile = $DiscardPile


func _ready() -> void:
	GameMaster.connect("player_hand_changed", _on_GameMaster_player_hand_changed)
	GameMaster.connect("discard_pile_changed", _on_GameMaster_discard_pile_changed)
	GameMaster.connect("deck_changed", _on_GameMaster_deck_changed)
	GameMaster.connect("cpu1_hand_changed", _on_GameMaster_cpu1_hand_changed)
	GameMaster.connect("cpu2_hand_changed", _on_GameMaster_cpu2_hand_changed)
	GameMaster.connect("cpu3_hand_changed", _on_GameMaster_cpu3_hand_changed)
	init_game()

func init_game() -> void:
	GameMaster.init_deck()
	
	GameMaster.draw_to_player_hand(7)
	GameMaster.draw_to_cpu_hand(7, 1)
	GameMaster.draw_to_cpu_hand(7, 2)
	GameMaster.draw_to_cpu_hand(7, 3)
	GameMaster.sort_player_hand()
	
	GameMaster.draw_to_discard(1)

func _on_GameMaster_player_hand_changed() -> void:
	player_hand.update_player_hand()

func _on_GameMaster_discard_pile_changed() -> void:
	discard_pile.update_discard_pile()

func _on_GameMaster_deck_changed() -> void:
	pass

func _on_GameMaster_cpu1_hand_changed() -> void:
	pass

func _on_GameMaster_cpu2_hand_changed() -> void:
	pass

func _on_GameMaster_cpu3_hand_changed() -> void:
	pass
