extends Sprite2D

func _ready() -> void:
	var card_color: String = get_parent().get_meta("Color")
	var card_value: String = get_parent().get_meta("Value")
	texture = GameMaster.sprite_map[card_color][card_value]
