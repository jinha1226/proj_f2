extends Label
## 생성 위치에서 위로 떠오르며 페이드아웃 후 자기 삭제.

func show_amount(amount: int, pos: Vector2) -> void:
	text = "+%d" % amount
	global_position = pos
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "global_position", pos + Vector2(0, -120), 0.8)
	tw.tween_property(self, "modulate:a", 0.0, 0.8)
	tw.chain().tween_callback(queue_free)
