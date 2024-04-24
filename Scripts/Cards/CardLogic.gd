extends Node2D

@export var lerp_speed = 0.1 #the speed of transitions in card movement and scaling
@export var scaling_amount = 1.2 #how big the card gets when hovered and selected
@export var CardBack: Sprite2D #the card back sprite

@onready var scale_animate = $AnimationPlayer #get the animation player for smooth scaling
@onready var scale_up_animation: Animation = scale_animate.get_animation("ScaleUp") #get the scale up animation and adjust its keyframes
@onready var scale_down_animation: Animation = scale_animate.get_animation("ScaleDown") #same as the scale up animation

var default_z_index: int #the z_index of the card when initialized
var default_scale: Vector2 #the scale of the card when initialized
var hovering = false #is the mouse hovering over the card
var scaled = false #has the card benn scaled
var dragging = false #is the card being dragged
var target_position: Vector2 

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

func _process(_delta: float) -> void:

	if dragging: #move the card smoothly to the mouse position
		position = position.lerp(target_position, lerp_speed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: #when the mouse drags the card
		if hovering:
			if not dragging and event.pressed:
				dragging = true
				GameMaster.is_a_card_being_dragged = true
		if dragging and not event.pressed:
			z_index = default_z_index #descale and normalize the card if the mouse isn't over the card when dragging stops
			scale_down_animation.track_set_key_value(0,0,scale)
			scale_animate.play("ScaleDown")
			scaled = false
			dragging = false
			GameMaster.is_a_card_being_dragged = false

	if event is InputEventMouseMotion and target_position != null:
		target_position = event.position

func _on_control_mouse_entered() -> void: #when the mouse starts hovering over the card
	hovering = true
	if not scaled:
			if not GameMaster.is_a_card_being_dragged:
				set_atop() #set the z scale higher than every other card
				scale_animate.play("ScaleUp")
				scaled = true

func _on_control_mouse_exited() -> void: #when the mouse stops hovering over the card
	hovering = false
	if not dragging:
			z_index = default_z_index
			scale_down_animation.track_set_key_value(0,0,scale)
			scale_animate.play("ScaleDown")
			scaled = false

func set_atop() -> void:
	var highest_z_index = 0
	for card in get_tree().get_nodes_in_group("Cards"): #find the highest z index in all the cards
		if card.z_index > highest_z_index:
			highest_z_index = card.z_index
	z_index = highest_z_index + 1
	
