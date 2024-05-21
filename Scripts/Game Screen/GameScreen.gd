extends Node2D

@onready var player_hand = $PlayerHand/HandManager
@onready var discard_pile = $DiscardPile
@onready var cpu1_hand = $Cpu1Hand/HandManager
@onready var cpu2_hand = $Cpu2Hand/HandManager
@onready var cpu3_hand = $Cpu3Hand/HandManager
@onready var game_hud = $GameHud
@onready var color_selector = $ColorSelector

func _ready() -> void:
	GameMaster.connect("player_hand_changed", _on_GameMaster_player_hand_changed)
	GameMaster.connect("discard_pile_changed", _on_GameMaster_discard_pile_changed)
	GameMaster.connect("cpu1_hand_changed", _on_GameMaster_cpu1_hand_changed)
	GameMaster.connect("cpu2_hand_changed", _on_GameMaster_cpu2_hand_changed)
	GameMaster.connect("cpu3_hand_changed", _on_GameMaster_cpu3_hand_changed)
	GameMaster.connect("new_round", _on_GameMaster_new_round)
	init_game()

func init_game() -> void:
	GameMaster.init_deck()
	
	GameMaster.draw_to_player_hand(7)
	GameMaster.draw_to_cpu_hand(7, 1)
	GameMaster.draw_to_cpu_hand(7, 2)
	GameMaster.draw_to_cpu_hand(7, 3)
	
	GameMaster.draw_to_discard(1)
	if GameMaster.get_top_discard_card().get_meta("Color") == "Wild":
		GameMaster.current_color = GameMaster.color_map.keys().pick_random()
	game_hud.change_pointer_color(GameMaster.color_map[GameMaster.current_color], 0.5)
	game_hud.change_take_card_button_color(GameMaster.color_map[GameMaster.current_color], 0.5)

func _on_GameMaster_player_hand_changed() -> void:
	player_hand.update_hand()

func _on_GameMaster_cpu1_hand_changed() -> void:
	cpu1_hand.update_hand()

func _on_GameMaster_cpu2_hand_changed() -> void:
	cpu2_hand.update_hand()

func _on_GameMaster_cpu3_hand_changed() -> void:
	cpu3_hand.update_hand()

func _on_GameMaster_discard_pile_changed() -> void:
	discard_pile.update_discard_pile()

func _on_GameMaster_new_round() -> void:
	match GameMaster.current_player:
		0:
			game_hud.change_pointer_position(0.0, 0.75)
			game_hud.change_take_card_button_color(GameMaster.color_map[GameMaster.current_color], 0.5)
			player_hand.can_play()
		1:
			game_hud.change_pointer_position(0.25, 0.75)
			game_hud.change_take_card_button_color(Color.WHITE, 0.5)
			player_hand.can_play(false)
			GameMaster.cpu_play(1)
		2:
			game_hud.change_pointer_position(0.5, 0.75)
			game_hud.change_take_card_button_color(Color.WHITE, 0.5)
			player_hand.can_play(false)
			GameMaster.cpu_play(2)
		3:
			game_hud.change_pointer_position(0.75, 0.75)
			game_hud.change_take_card_button_color(Color.WHITE, 0.5)
			player_hand.can_play(false)
			GameMaster.cpu_play(3)
	
	print(str(GameMaster.players[GameMaster.current_player]))

func _on_card_played(card_color: String, card_value: String) -> void:
	match card_color:
		"Blue", "Green", "Red", "Yellow":
			GameMaster.current_color = card_color
		"Wild":
			if GameMaster.current_player == 0:
				color_selector.show()
				await color_selector.color_selected
			else:
				GameMaster.current_color = GameMaster.color_map.keys().pick_random()
	game_hud.change_pointer_color(GameMaster.color_map[GameMaster.current_color], 0.5)
	
	var skip = false
	var reverse = false
	if card_value == "Skip":
		skip = true
	elif card_value == "Reverse":
		reverse = true
	GameMaster.next_turn(skip, reverse)
