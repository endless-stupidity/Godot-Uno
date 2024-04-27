extends Node2D

func update_discard_pile() -> void:
	for child in get_children():
		remove_child(child)
	var shown_card = GameMaster.discard_pile[-1]
	shown_card.set_meta("HoverEffect", false)
	add_child(shown_card)
