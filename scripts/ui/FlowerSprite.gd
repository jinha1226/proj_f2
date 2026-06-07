extends Node2D
## 탑다운 픽셀덩어리 꽃(Tiny Terraces식). 원점=꽃밭 중심.
## 초록 잎 패치 위에 작은 꽃송이(꽃잎4+중심) 픽셀이 박힌다.
## 레벨이 오를수록 패치가 넓어지고 꽃송이 수가 는다.

const PX := 8.0  # art-pixel 한 칸의 화면 크기

## 꽃송이를 흩어놓을 잎 패치 내부 좌표(art-pixel). 레벨이 오르며 앞에서부터 사용.
const BLOOM_OFFSETS := [
	Vector2i(0, 0), Vector2i(-3, -2), Vector2i(3, -1), Vector2i(-1, 3),
	Vector2i(2, 3), Vector2i(-4, 1), Vector2i(4, 2), Vector2i(0, -4), Vector2i(-2, -4),
]

var petal_color := Palette.CREAM
var center_color := Palette.YELLOW
var petal_count := 8  # (호환용; 미사용)
var level := 0

func configure(p_petal: Color, p_center: Color, p_petals: int) -> void:
	petal_color = p_petal
	center_color = p_center
	petal_count = p_petals

func set_level(l: int) -> void:
	level = l
	visible = level > 0
	queue_redraw()

func _blk(ax: int, ay: int, col: Color, s: float) -> void:
	draw_rect(Rect2(ax * s - s * 0.5, ay * s - s * 0.5, s, s), col, true)

func _draw() -> void:
	if level <= 0:
		return
	var grow: int = min(level, 8)
	var s := PX
	# 잎 패치(원형) — 두 톤 초록으로 결정적 체크
	var leaf_r: int = 3 + grow / 2
	for ax in range(-leaf_r, leaf_r + 1):
		for ay in range(-leaf_r, leaf_r + 1):
			if ax * ax + ay * ay <= leaf_r * leaf_r:
				_blk(ax, ay, Palette.GREEN if (ax + ay) % 2 == 0 else Palette.GREEN_DARK, s)
	# 꽃송이 — 레벨로 개수 증가
	var blooms: int = min(1 + grow, BLOOM_OFFSETS.size())
	for i in range(blooms):
		_draw_bloom(BLOOM_OFFSETS[i].x, BLOOM_OFFSETS[i].y, s)

func _draw_bloom(cx: int, cy: int, s: float) -> void:
	_blk(cx, cy - 1, petal_color, s)
	_blk(cx - 1, cy, petal_color, s)
	_blk(cx + 1, cy, petal_color, s)
	_blk(cx, cy + 1, petal_color, s)
	_blk(cx, cy, center_color, s)
