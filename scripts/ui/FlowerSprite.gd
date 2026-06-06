extends Node2D
## 코드로 그리는 꽃 한 송이. 원점 = 줄기 밑동(땅). 위로 자란다.
## 레벨 0이면 안 보이고, 레벨이 오를수록 줄기가 길고 꽃이 커진다(키우기).

var petal_color: Color = Color.WHITE
var center_color: Color = Color(1, 0.85, 0.2)
var petal_count: int = 8
var level: int = 0

func configure(p_petal: Color, p_center: Color, p_petals: int) -> void:
	petal_color = p_petal
	center_color = p_center
	petal_count = p_petals

func set_level(l: int) -> void:
	level = l
	visible = level > 0
	queue_redraw()

func _draw() -> void:
	if level <= 0:
		return
	var grow: int = min(level, 10)
	var stem_h: float = 90.0 + grow * 18.0
	var flower_r: float = 34.0 + grow * 6.0
	var petal_r: float = flower_r * 0.55
	var stem_col := Color(0.30, 0.55, 0.25)
	# 줄기
	draw_line(Vector2.ZERO, Vector2(0, -stem_h), stem_col, 8.0)
	# 잎사귀
	draw_circle(Vector2(16, -stem_h * 0.45), 16.0, Color(0.34, 0.6, 0.28))
	# 꽃잎 (중심 주위로 원형 배치)
	var center := Vector2(0, -stem_h)
	for i in petal_count:
		var ang: float = TAU * i / petal_count
		var pos := center + Vector2(cos(ang), sin(ang)) * petal_r
		draw_circle(pos, petal_r * 0.95, petal_color)
	# 꽃 중심
	draw_circle(center, flower_r * 0.45, center_color)
