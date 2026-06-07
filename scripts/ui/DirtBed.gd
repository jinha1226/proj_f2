extends Node2D
## 탑다운 흙 화단 + 나무 테두리. Tiny Terraces식 "액자 흙밭".

const BED := Rect2(10, 10, 1060, 1900)  # 흙밭 영역(화면 가득)
const FRAME := 18.0                     # 나무틀 두께
const STEP := 36.0                      # 흙 얼룩 격자 간격

func _draw() -> void:
	# 나무틀 (바깥 진한 + 안쪽 밝은)
	draw_rect(BED.grow(FRAME), Palette.WOOD_DARK, true)
	draw_rect(BED.grow(FRAME * 0.45), Palette.WOOD, true)
	# 흙 바탕
	draw_rect(BED, Palette.DIRT, true)
	# 흙 얼룩 (결정적 격자 — 랜덤 없음)
	var cols := int(BED.size.x / STEP)
	var rows := int(BED.size.y / STEP)
	for i in range(cols):
		for j in range(rows):
			if (i * 13 + j * 7) % 5 == 0:
				var x := BED.position.x + i * STEP
				var y := BED.position.y + j * STEP
				draw_rect(Rect2(x, y, 16, 16), Palette.DIRT_DARK, true)
