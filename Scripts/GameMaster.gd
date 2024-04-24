extends Node

var is_a_card_being_dragged: bool
var player_count: int = 1

var deck = []
var discard_pile = []
var player_hand = []

const sprite_map: Dictionary = {
	"Blue": {
		"0": preload("res://Assets/Cards/Blue/blue_0.png"),
		"1": preload("res://Assets/Cards/Blue/blue_1.png"),
		"2": preload("res://Assets/Cards/Blue/blue_2.png"),
		"3": preload("res://Assets/Cards/Blue/blue_3.png"),
		"4": preload("res://Assets/Cards/Blue/blue_4.png"),
		"5": preload("res://Assets/Cards/Blue/blue_5.png"),
		"6": preload("res://Assets/Cards/Blue/blue_6.png"),
		"7": preload("res://Assets/Cards/Blue/blue_7.png"),
		"8": preload("res://Assets/Cards/Blue/blue_8.png"),
		"9": preload("res://Assets/Cards/Blue/blue_9.png"),
		"Picker": preload("res://Assets/Cards/Blue/blue_picker.png"),
		"Reverse": preload("res://Assets/Cards/Blue/blue_reverse.png"),
		"Skip": preload("res://Assets/Cards/Blue/blue_skip.png"),
	},
	"Green": {
		"0": preload("res://Assets/Cards/Green/green_0.png"),
		"1": preload("res://Assets/Cards/Green/green_1.png"),
		"2": preload("res://Assets/Cards/Green/green_2.png"),
		"3": preload("res://Assets/Cards/Green/green_3.png"),
		"4": preload("res://Assets/Cards/Green/green_4.png"),
		"5": preload("res://Assets/Cards/Green/green_5.png"),
		"6": preload("res://Assets/Cards/Green/green_6.png"),
		"7": preload("res://Assets/Cards/Green/green_7.png"),
		"8": preload("res://Assets/Cards/Green/green_8.png"),
		"9": preload("res://Assets/Cards/Green/green_9.png"),
		"Picker": preload("res://Assets/Cards/Green/green_picker.png"),
		"Reverse": preload("res://Assets/Cards/Green/green_reverse.png"),
		"Skip": preload("res://Assets/Cards/Green/green_skip.png"),
	},
	"Red": {
		"0": preload("res://Assets/Cards/Red/red_0.png"),
		"1": preload("res://Assets/Cards/Red/red_1.png"),
		"2": preload("res://Assets/Cards/Red/red_2.png"),
		"3": preload("res://Assets/Cards/Red/red_3.png"),
		"4": preload("res://Assets/Cards/Red/red_4.png"),
		"5": preload("res://Assets/Cards/Red/red_5.png"),
		"6": preload("res://Assets/Cards/Red/red_6.png"),
		"7": preload("res://Assets/Cards/Red/red_7.png"),
		"8": preload("res://Assets/Cards/Red/red_8.png"),
		"9": preload("res://Assets/Cards/Red/red_9.png"),
		"Picker": preload("res://Assets/Cards/Red/red_picker.png"),
		"Reverse": preload("res://Assets/Cards/Red/red_reverse.png"),
		"Skip": preload("res://Assets/Cards/Red/red_skip.png"),
	},
	"Yellow": {
		"0": preload("res://Assets/Cards/Yellow/yellow_0.png"),
		"1": preload("res://Assets/Cards/Yellow/yellow_1.png"),
		"2": preload("res://Assets/Cards/Yellow/yellow_2.png"),
		"3": preload("res://Assets/Cards/Yellow/yellow_3.png"),
		"4": preload("res://Assets/Cards/Yellow/yellow_4.png"),
		"5": preload("res://Assets/Cards/Yellow/yellow_5.png"),
		"6": preload("res://Assets/Cards/Yellow/yellow_6.png"),
		"7": preload("res://Assets/Cards/Yellow/yellow_7.png"),
		"8": preload("res://Assets/Cards/Yellow/yellow_8.png"),
		"9": preload("res://Assets/Cards/Yellow/yellow_9.png"),
		"Picker": preload("res://Assets/Cards/Yellow/yellow_picker.png"),
		"Reverse": preload("res://Assets/Cards/Yellow/yellow_reverse.png"),
		"Skip": preload("res://Assets/Cards/Yellow/yellow_skip.png"),
	},
	"Wild": {
		"ColorChanger": preload("res://Assets/Cards/Wild/wild_colorchanger.png"),
		"PickFour": preload("res://Assets/Cards/Wild/wild_pickfour.png"),
	},
}

func clear_deck() -> void:
	deck = []

func clear_discard_pile() -> void:
	discard_pile = []

func clear_player_hand() -> void:
	player_hand = []

func fill_deck() -> void:
	for color in sprite_map.keys():
		for value in sprite_map[color].keys():
			for _i in range(player_count):
				var card = preload("res://Scenes/Cards/Card.tscn")
				card.set_meta("Color", color)
				card.set_meta("Value", value)
				deck.append(card)

func shuffle_deck() -> void:
	deck.shuffle()

func draw_from_deck(card_count: int) -> Array:
	var drawn_cards = []
	if deck.size() > card_count:
		for _i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		return drawn_cards
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))
		return []
