extends Node2D

var vertical_card_curve: Curve = preload("res://Assets/Curves/VerticalCardCurve.tres") #the curve for the x offset of the cards

@export var spread_amount: int = 150 #how much should the cards spread on the x axis

func clear_cpu3_hand() -> void: #kiils all the children of the player hand
	for child in get_children():
		remove_child(child)

func update_cpu3_hand() -> void: #updates the player hand based on the GameMaster.player_hand
	var tween = create_tween().set_parallel()
	
	clear_cpu3_hand()
	var card_count = GameMaster.cpu3_hand.size() #how many cards are there
	
	if card_count < 6 and card_count > 3: #change the spread amount based on the card count
		spread_amount = 50
	elif card_count < 4:
		spread_amount = 25
	elif card_count < 15:
		spread_amount = 100
	
	if card_count > 1:
		for card in GameMaster.cpu3_hand:
			add_child(card)

		for card in get_children(): #spread, rotate and offset the y axis of the cards based on their index
			var hand_ratio = float(card.get_index()) / float(card_count - 1)
			var local_position := Vector2(vertical_card_curve.sample(hand_ratio) * spread_amount, 0)
			tween.tween_property(card, "position", local_position, 0.5)
			
			card.set_meta("HoverEffect", false)
			card.set_meta("CanBePlayed", false)
			card.set_card_back(true)
			
			
	else: #if there's only one card left, make sure to center it
		var card = GameMaster.cpu3_hand[0]
		var hand_ratio = 0.5
		var local_position = Vector2(vertical_card_curve.sample(hand_ratio), vertical_card_curve.sample(hand_ratio))
		tween.tween_property(card, "position", local_position, 0.5)
		card.set_meta("HoverEffect", false)
		card.set_meta("CanBePlayed", false)
		card.set_card_back(true)
		add_child(card)
