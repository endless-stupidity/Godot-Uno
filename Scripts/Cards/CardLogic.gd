extends Node2D

@export var lerp_speed = 0.1 #the speed of transitions in card movement and scaling
@export var scaling_amount = 1.2 #how big the card gets when hovered and selected
@export var CardBack: Sprite2D #the card back sprite
@export var angle_x_max: float
@export var angle_y_max: float

@onready var scale_animate = $AnimationPlayer #get the animation player for smooth scaling
@onready var scale_up_animation: Animation = scale_animate.get_animation("ScaleUp") #get the scale up animation and adjust its keyframes
@onready var scale_down_animation: Animation = scale_animate.get_animation("ScaleDown") #same as the scale up animation

var default_z_index: int #the z_index of the card when initialized
var default_scale: Vector2 #the scale of the card when initialized
var hovering = false #is the mouse hovering over the card
var scaled = false #has the card benn scaled
var dragging = false #is the card being dragged
var target_position: Vector2 

func _process(delta: float) -> void:
	pass

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
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if hovering and event.pressed:
				print_debug(get_meta("Color") + get_meta("Value") + " is played")
				
	if hovering:
		var mouse_pos = get_local_mouse_position()
		var diff: Vector2 = (position + $CardFace.size) - mouse_pos
		
		var lerp_val_x: float = remap(mouse_pos.x, 0.0, $CardFace.size.x, 0, 1)
		var lerp_val_y: float = remap(mouse_pos.y, 0.0, $CardFace.size.y, 0, 1)
		
		var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max,angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
		
		$CardFace.material.set_shader_parameter("x_rot", rot_y)
		$CardFace.material.set_shader_parameter("y_rot", rot_x)
		$CardBack.material.set_shader_parameter("x_rot", rot_y)
		$CardBack.material.set_shader_parameter("y_rot", rot_x)

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
	
