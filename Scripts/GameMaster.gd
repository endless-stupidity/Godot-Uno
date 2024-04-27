extends Node

signal player_hand_changed #when a card is added to or removed from the player hand
signal discard_pile_changed #when a card is added to or removed from the discard pile
signal deck_changed #when a card is added to or removed from the deck

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
	emit_signal("deck_changed")

func clear_discard_pile() -> void: #empty the discard pile
	discard_pile = []
	emit_signal("discard_pile_changed")

func clear_player_hand() -> void: #empty the player hand
	player_hand = []
	emit_signal("player_hand_changed")

func fill_deck() -> void: #generate cards based on the number of players
	for color in sprite_map.keys():
		for value in sprite_map[color].keys():
			for _i in range(player_count):
				var card = card_scene.instantiate()
				card.set_meta("Color", color)
				card.set_meta("Value", value)
				deck.append(card)
	emit_signal("deck_changed")

func shuffle_deck() -> void: #shuffle the cards in the deck
	deck.shuffle()
	emit_signal("deck_changed")

func init_deck() -> void: #clear, fill, and then shuffle the deck
	clear_deck()
	fill_deck()
	shuffle_deck()
	emit_signal("deck_changed")

func draw_from_deck(card_count: int) -> Array: #removes the amount of wanted cards from the deck and returns them
	var drawn_cards = []
	if deck.size() > card_count:
		for i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		emit_signal("deck_changed")
		return drawn_cards
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))
		return []

func draw_to_player_hand(card_count: int) -> void: #removes the amount of wanted cards from the deck and moves them to player's hand
	var drawn_cards = []
	if deck.size() > card_count:
		for i in range(card_count):
			var card = deck.pop_back()
			drawn_cards.append(card)
		player_hand += drawn_cards
		emit_signal("deck_changed")
		emit_signal("player_hand_changed")
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))

func draw_to_discard(card_count: int) -> void: #removes the amount of random wanted cards from the deck and moves them to the discard pile
	var drawn_cards = []
	if deck.size() > card_count:
		for i in range(card_count):
			var card = deck.pick_random()
			drawn_cards.append(card)
		discard_pile += drawn_cards
		for card in drawn_cards:
			deck.erase(card)
		emit_signal("deck_changed")
		emit_signal("discard_pile_changed")
	else:
		print_debug("Not enough cards in deck to draw " + str(card_count))

func play_to_discard(played_card: Variant): #removes the given card from the player hand and moves it to the discard pile
	discard_pile.append(played_card)
	player_hand.erase(played_card)
	emit_signal("player_hand_changed")
	emit_signal("discard_pile_changed")

func get_top_discard_card() -> Node2D: #returns the top card in the discard pile
	return discard_pile[-1]

func sort_player_hand() -> void: #sorts the cards in the player's hand
	player_hand.sort_custom(compare_cards)
	emit_signal("player_hand_changed")

func compare_cards(card1, card2): #the sorting algorithm which first sorts cards based on color then value
	var color_order = {"Blue": 0, "Green": 1, "Red": 2, "Yellow": 3, "Wild": 4}
	var card1_color = card1.get_meta("Color")
	var card2_color = card2.get_meta("Color")
	if color_order[card1_color] != color_order[card2_color]:
		return color_order[card1_color] < color_order[card2_color]
	else:
		return card1.get_meta("Value") < card2.get_meta("Value")
