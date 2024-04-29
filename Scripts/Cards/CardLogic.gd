extends Node2D

@export var scaling_amount = 1.2 #how big the card gets when hovered and selected
@export var angle_x_max: float #the intensity of the 3d rotation effect
@export var angle_y_max: float #same as the last var

@onready var scale_animate = $AnimationPlayer #get the animation player for smooth scaling
@onready var scale_up_animation: Animation = scale_animate.get_animation("ScaleUp") #get the scale up animation and adjust its keyframes
@onready var scale_down_animation: Animation = scale_animate.get_animation("ScaleDown") #same as the scale up animation

var default_z_index: int #the z_index of the card when initialized
var default_scale: Vector2 #the scale of the card when initialized
var hovering = false #is the mouse hovering over the card

func _ready() -> void:
	default_z_index = z_index
	default_scale = scale
	if (get_meta("CardBack")): #set card face or card back based on the metadata
		get_node("CardFace").visible = false
		get_node("CardBack").visible = true
	elif (!get_meta("CardBack")):
		get_node("CardFace").visible = true
		get_node("CardBack").visible = false
	name = get_meta("Color") + get_meta("Value")
	scale_up_animation.track_set_key_value(0,0,default_scale) #initialize the proper animation keyframe values
	scale_up_animation.track_set_key_value(0,1,scale * scaling_amount)
	scale_down_animation.track_set_key_value(0,0,scale)
	scale_down_animation.track_set_key_value(0,1,default_scale)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: #when a card is clicked on
		if event.button_index == MOUSE_BUTTON_LEFT:
			if hovering and event.pressed:
				if can_be_played():
					play_card()
	if hovering and get_meta("HoverEffect"): #idk what math is used here but it works and gives the card the 3d perspective we all love
		var mouse_pos = get_local_mouse_position()

		var lerp_val_x: float = remap(-mouse_pos.y, 0.0, $CardFace.size.x/2, 0, 1)
		var lerp_val_y: float = remap(-mouse_pos.x, 0.0, $CardFace.size.y/2, 0, 1)

		var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max,angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))

		$CardFace.material.set_shader_parameter("x_rot", rot_x)
		$CardFace.material.set_shader_parameter("y_rot", rot_y)
		$CardBack.material.set_shader_parameter("x_rot", rot_x)
		$CardBack.material.set_shader_parameter("y_rot", rot_y)

func _on_control_mouse_entered() -> void: #when the mouse starts hovering over the card
	hovering = true
	if get_meta("HoverEffect"):
		set_atop() #set the z scale higher than every other card
		scale_animate.play("ScaleUp")

func _on_control_mouse_exited() -> void: #when the mouse stops hovering over the card
	hovering = false
	z_index = default_z_index
	scale_down_animation.track_set_key_value(0,0,scale)
	scale_animate.play("ScaleDown")
	
	$CardFace.material.set_shader_parameter("x_rot", 0) #reset the 3d perspective (hopefully)
	$CardFace.material.set_shader_parameter("y_rot", 0)
	$CardBack.material.set_shader_parameter("x_rot", 0)
	$CardBack.material.set_shader_parameter("y_rot", 0)

func set_atop() -> void:
	var highest_z_index = 0
	for card in get_tree().get_nodes_in_group("Cards"): #find the highest z index in all the cards
		if card.z_index > highest_z_index:
			highest_z_index = card.z_index
	z_index = highest_z_index + 1
	
func play_card() -> void: #remove the card from the player hand and add it to the discard pile
	var played_card_index = GameMaster.player_hand.find(self)
	var played_card = GameMaster.player_hand[played_card_index]
	GameMaster.play_to_discard(played_card)

func can_be_played() -> bool: #check if the card can be played according to UNO rules
	var played_card_color = get_meta("Color")
	var played_card_value = get_meta("Value")
	if get_meta("CanBePlayed"):
		if played_card_color == "Wild":
			return true
		elif played_card_color == GameMaster.get_top_discard_card().get_meta("Color"):
			return true
		elif played_card_value == GameMaster.get_top_discard_card().get_meta("Value"):
			return true
		else:
			return false
	else:
		return false
