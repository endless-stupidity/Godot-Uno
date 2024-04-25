extends Node

var player_count: int = 1 #how many players are playing
var card_scene = preload("res://Scenes/Cards/Card.tscn") #the card scene

var deck = [] #the deck from which all cards are drawn
var discard_pile = [] #the pile where played cards go to
var player_hand = [] #cards in the player's hand

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

func clear_deck() -> void: #empty the deck
	deck = []

func clear_discard_pile() -> void: #empty the discard pile
	discard_pile = []

func clear_player_hand() -> void: #empty the player hand
	player_hand = []

func fill_deck() -> void: #generate cards based on the number of players
	for color in sprite_map.keys():
		for value in sprite_map[color].keys():
			for _i in range(player_count):
				var card = card_scene.instantiate()
				card.set_meta("Color", color)
				card.set_meta("Value", value)
				deck.append(card)

func shuffle_deck() -> void: #shuffle the cards in the deck
	deck.shuffle()

func init_deck() -> void: #clear, fill, and then shuffle the deck
	clear_deck()
	fill_deck()
	shuffle_deck()

func draw_from_deck(card_count: int) -> Array: #removes the amount of wanted cards from the deck and returns them
	var drawn_cards = []
	if deck.size() > card_count:
		for _i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		return drawn_cards
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))
		return []

func draw_to_player_hand(card_count: int) -> void: #removes the amount of wanted cards from the deck and moves them to player's hand
	var drawn_cards = []
	if deck.size() > card_count:
		for _i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		player_hand += drawn_cards
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))

func sort_player_hand() -> void: #sorts the cards in the player's hand
	player_hand.sort_custom(compare_cards)

func draw_to_discard(card_count: int) -> void: #removes the amount of wanted cards from the deck and moves them to the discard pile
	var drawn_cards = []
	if deck.size() > card_count:
		for _i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		discard_pile += drawn_cards
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))

func compare_cards(card1, card2): #the sorting algorithm which first sorts cards based on color then value
	var color_order = {"Blue": 0, "Green": 1, "Red": 2, "Yellow": 3, "Wild": 4}
	var card1_color = card1.get_meta("Color")
	var card2_color = card2.get_meta("Color")
	if color_order[card1_color] != color_order[card2_color]:
		return color_order[card1_color] < color_order[card2_color]
	else:
		return card1.get_meta("Value") < card2.get_meta("Value")
