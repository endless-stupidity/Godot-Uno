extends Node2D

func clear_discard_pile() -> void:
	for child in get_children():
		remove_child(child)

func update_discard_pile() -> void:
	var shown_card = GameMaster.discard_pile[-1]
	shown_card.set_meta("HoverEffect", false)
	shown_card.set_meta("CanBePlayed", false) #make sure a played card can't be played again
	shown_card.set_meta("CardBack", false)
	shown_card.position = Vector2(0, 0)
	add_child(shown_card)
