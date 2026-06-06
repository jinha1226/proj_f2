extends Node2D
## 미니멀 픽셀 꽃. 작은 블록(art-pixel) 몇 개로만 그린다.
## 꽃잎 한 장 = 블록 한 칸. PX 값만 바꾸면 전체 크기가 조절된다.
## 레벨 0이면 숨김, 레벨이 오르면 줄기가 길고 블록이 살짝 커진다.

const PX := 6.0  # art-pixel 한 칸의 화면 크기(px). 작게 = 더 미니멀.

var petal_color := Color.WHITE
var center_color := Color(1, 0.85, 0.2)
var petal_count := 8  # >=10이면 꽃잎 8장(큰 꽃), 아니면 4장
var level := 0

func configure(p_petal: Color, p_center: Color, p_petals: int) -> void:
	petal_color = p_petal
	center_color = p_center
	petal_count = p_petals

func set_level(l: int) -> void:
	level = l
	visible = level > 0
	queue_redraw()

## art 좌표(ax,ay)에 블록 한 칸. ay가 음수면 위쪽. 원점=줄기 밑동(땅).
func _blk(ax: int, ay: int, col: Color, s: float) -> void:
	draw_rect(Rect2(ax * s - s * 0.5, ay * s - s * 0.5, s, s), col, true)

func _draw() -> void:
	if level <= 0:
		return
	var grow: int = min(level, 8)
	var s: float = PX * (1.0 + grow * 0.16)
	var stem_col := Color(0.30, 0.55, 0.25)
	var stem: int = 3 + grow            # 줄기 블록 길이(레벨로 길어짐)
	for i in range(stem):               # 땅에서 위로 줄기
		_blk(0, -(i + 1), stem_col, s)
	var hc: int = -(stem + 1)           # 꽃 중심 art-y
	# 꽃잎 (다이아몬드 4장, 큰 꽃이면 모서리 4장 추가 = 8장)
	var petals := [Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)]
	if petal_count >= 10:
		petals.append_array([Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)])
	for p in petals:
		_blk(p.x, hc + p.y, petal_color, s)
	# 꽃 중심 한 칸
	_blk(0, hc, center_color, s)
	# 잎사귀 한 칸
	_blk(1, -int(stem / 2.0), Color(0.34, 0.6, 0.28), s)
