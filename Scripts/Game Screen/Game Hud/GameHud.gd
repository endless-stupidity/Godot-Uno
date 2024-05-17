extends Control

@onready var path_follower = $TurnIndicatorPath/PathFollow2D
@onready var pointer = $TurnIndicatorPath/PathFollow2D/Pointer

func change_pointer_color(target_color: Color, transition_time: float = 0) -> void:
	var tween = create_tween()
	tween.tween_property(pointer, "color", target_color, transition_time)

func change_pointer_position(target_progress_ratio: float, transition_time: float = 0) -> void:
	var tween = create_tween().parallel()
	tween.set_trans(Tween.TRANS_CUBIC)
	var current_progress_ratio = path_follower.progress_ratio
	if transition_time == 0:
		path_follower.progress_ratio = target_progress_ratio
	else:
		if GameMaster.clockwise:
			if target_progress_ratio < current_progress_ratio:
				tween.tween_property(path_follower, "progress_ratio", 1, transition_time)
				tween.chain().tween_property(path_follower, "progress_ratio", 0, 0)
				tween.chain().tween_property(path_follower, "progress_ratio", target_progress_ratio, transition_time)
			else:
				tween.tween_property(path_follower, "progress_ratio", target_progress_ratio, transition_time).set_ease(Tween.EASE_OUT_IN)
		elif not GameMaster.clockwise:
			if target_progress_ratio > current_progress_ratio:
				tween.tween_property(path_follower, "progress_ratio", 0, transition_time)
				tween.chain().tween_property(path_follower, "progress_ratio", 1, 0)
				tween.chain().tween_property(path_follower, "progress_ratio", target_progress_ratio, transition_time)
			else:
				tween.tween_property(path_follower, "progress_ratio", target_progress_ratio, transition_time)
