extends Area2D

var horizontal_card_curve: Curve = preload("res://Assets/Curves/HorizontalCardCurve.tres") #the curve for the y offset of the cards
var card_rotate_curve: Curve = preload("res://Assets/Curves/PlayerHandCardRotate.tres") #the curve for the rotation of the cards
var card_spacing_curve: Curve = preload("res://Assets/Curves/CardSpacingCurve.tres")

@export var rotation_factor: float = 0.3 #how much should the cards be rotated
@export var max_card_count: int = 30 #how many cards can be in a player's hand before shit goes wild

func clear_player_hand() -> void: #kiils all the children of the player hand
	for child in get_children():
		if child != $PlayerHandArea:
			remove_child(child)

func update_player_hand() -> void: #updates the player hand based on the GameMaster.player_hand
	clear_player_hand()
	var card_count = GameMaster.player_hand.size() #how many cards are there
	var area_size = $PlayerHandArea.shape.get_rect().size #get the size of the player hand area
	var spacing = card_spacing_curve.sample(remap(card_count, 1, max_card_count, 0, 1))
	
	var total_width = spacing * (card_count - 1)
	var start_position_x = $PlayerHandArea.shape.get_rect().position.x
	
	if card_count > 1:
		var counter = 0
		for card in GameMaster.player_hand: #math magic i don't understand but which works. postitions and rotates the cards in the hand
			var position_x = start_position_x + spacing * counter
			var normalized_x = (position_x - start_position_x) / total_width
			var position_y = area_size.y / 2 - horizontal_card_curve.sample(normalized_x)
			card.position = Vector2(position_x, position_y) 
			
			card.set_meta("HoverEffect", true)
			card.set_meta("CanBePlayed", true)
			card.set_meta("CardBack" , false)
			
			var rotation_amount = card_rotate_curve.sample(normalized_x)
			card.rotation = rotation_amount * rotation_factor
			
			add_child(card)
			counter += 1
	else:
		var card = GameMaster.player_hand[0]
		card.position = Vector2(area_size.x / 2, area_size.y / 2)
		card.rotation = 0
		add_child(card)
