extends Node2D
## 심기 모드일 때만 정원 타일 격자선을 그린다.

func _ready() -> void:
	PlantMode.changed.connect(_on_changed)
	visible = false

func _on_changed(active_id: String) -> void:
	visible = active_id != ""
	queue_redraw()

func _draw() -> void:
	if not visible:
		return
	var col := Color(1, 1, 1, 0.18)
	var a := Grid.AREA
	for i in range(Grid.cols() + 1):
		var x := a.position.x + i * Grid.TILE
		draw_line(Vector2(x, a.position.y), Vector2(x, a.end.y), col, 2.0)
	for j in range(Grid.rows() + 1):
		var y := a.position.y + j * Grid.TILE
		draw_line(Vector2(a.position.x, y), Vector2(a.end.x, y), col, 2.0)
