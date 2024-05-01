extends Node2D

var vertical_card_curve: Curve = preload("res://Assets/Curves/VerticalCardCurve.tres") #the curve for the x offset of the cards
var horizontal_card_curve: Curve = preload("res://Assets/Curves/HorizontalCardCurve.tres") #the curve for the y offset of the cards
var card_rotate_curve: Curve = preload("res://Assets/Curves/CardHandRotateCurve.tres") #the curve for the rotation of the cards

@export var rotation_factor: float = 0.3 #how much should the cards be rotated
@export var spread_amount: int = 300 #how much should the cards spread on the x axis


func clear_player_hand() -> void: #kiils all the children of the player hand
	for child in get_children():
		remove_child(child)

func update_player_hand() -> void: #updates the player hand based on the GameMaster.player_hand
	var tween = create_tween().set_parallel()
	
	clear_player_hand()
	var card_count = GameMaster.player_hand.size() #how many cards are there
	
	if card_count < 6 and card_count > 3: #change the spread amount based on the card count
		spread_amount = 100
	elif card_count < 4:
		spread_amount = 50
	elif card_count < 15:
		spread_amount = 200
	
	if card_count > 1:
		for card in GameMaster.player_hand:
			add_child(card)

		for card in get_children(): #spread, rotate and offset the y axis of the cards based on their index
			var hand_ratio = float(card.get_index()) / float(card_count - 1)
			var local_position := Vector2(vertical_card_curve.sample(hand_ratio) * spread_amount, horizontal_card_curve.sample(hand_ratio))
			tween.tween_property(card, "position", local_position, 0.5)
			
			card.set_meta("HoverEffect", true)
			card.set_meta("CanBePlayed", true)
			card.set_meta("CardBack" , false)
			
			var rotation_amount = card_rotate_curve.sample(hand_ratio)
			card.rotation = rotation_amount * rotation_factor
			
	else: #if there's only one card left, make sure to center it
		var card = GameMaster.player_hand[0]
		var hand_ratio = 0.5
		var local_position = Vector2(vertical_card_curve.sample(hand_ratio), vertical_card_curve.sample(hand_ratio))
		tween.tween_property(card, "position", local_position, 0.5)
		card.rotation = 0
		add_child(card)
