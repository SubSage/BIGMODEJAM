extends Node2D
class_name Debris

func collected():
	if is_queued_for_deletion() or not is_instance_valid(self):
		return

	var tween = create_tween()
	tween.tween_property($Icon6, "scale", Vector2.ONE * .3, .25).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(queue_free)
