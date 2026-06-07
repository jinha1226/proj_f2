extends Node2D
## 탑다운 큰 흙밭 + 나무 테두리 + 돌바닥. 새싹·자갈 디테일로 Tiny Terraces 분위기.

const WORLD := Rect2(0, 0, 2160, 3600)      # 전체 월드(돌바닥 포함)
const BED := Rect2(90, 90, 1980, 3420)      # 흙밭(나무틀 안)
const FRAME := 26.0
const STEP := 48.0                          # 디테일 격자 간격

func _draw() -> void:
	# 돌바닥
	draw_rect(WORLD, Palette.STONE, true)
	# 나무틀
	draw_rect(BED.grow(FRAME), Palette.WOOD_DARK, true)
	draw_rect(BED.grow(FRAME * 0.5), Palette.WOOD, true)
	# 흙
	draw_rect(BED, Palette.DIRT, true)
	# 디테일(결정적 격자 — 랜덤 없음): 어두운 흙 / 새싹 / 자갈
	var cols := int(BED.size.x / STEP)
	var rows := int(BED.size.y / STEP)
	for i in range(cols):
		for j in range(rows):
			var x := BED.position.x + i * STEP
			var y := BED.position.y + j * STEP
			match (i * 13 + j * 7) % 9:
				0, 6:
					draw_rect(Rect2(x, y, 14, 14), Palette.DIRT_DARK, true)
				3:
					draw_rect(Rect2(x + 4, y, 5, 13), Palette.GREEN_DARK, true)  # 새싹
				8:
					draw_rect(Rect2(x + 6, y + 6, 9, 6), Palette.STONE_DARK, true)  # 자갈
