extends Node2D
## 탑다운 잎 덩어리 + 꽃송이(Tiny Terraces식 오리지널). 원점=중심.
## 잎이 원형으로 퍼져서 옆 송이와 겹친다 → 꽉 심으면 흙이 덮인다.
## 레벨이 오를수록 잎 덩어리가 커지고 꽃이 많아진다.

const PX := 9.0  # art-pixel 한 칸의 화면 크기

const BLOOM_OFFSETS := [
	Vector2i(0, 0), Vector2i(-3, -2), Vector2i(3, -1), Vector2i(-2, 3),
	Vector2i(2, 2), Vector2i(-4, 0), Vector2i(4, 2), Vector2i(1, -4), Vector2i(-1, 4),
]

var petal_color: Color = Color(0.87, 0.84, 0.77)  # configure()가 덮어씀
var center_color: Color = Color(0.83, 0.65, 0.18)
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
	var rad: int = 4 + grow             # 잎 덩어리 반지름(블록) — 옆과 겹치게 큼
	# 땅 그림자
	draw_rect(Rect2(-rad * s, rad * 0.4 * s, rad * 2 * s, s * 1.1), Color(0, 0, 0, 0.10), true)
	# 잎 덩어리(원형) — 두 톤 + 아래 음영
	for ax in range(-rad, rad + 1):
		for ay in range(-rad, rad + 1):
			if ax * ax + ay * ay <= rad * rad:
				var c: Color = Palette.GREEN if (ax + ay) % 2 == 0 else Palette.LEAF
				if ay >= rad - 2:           # 아래쪽 음영
					c = Palette.GREEN_DARK
				_blk(ax, ay, c, s)
	# 꽃송이 — 레벨로 개수 증가
	var blooms: int = min(2 + grow, BLOOM_OFFSETS.size())
	for i in range(blooms):
		_draw_bloom(BLOOM_OFFSETS[i].x, BLOOM_OFFSETS[i].y, s)

func _draw_bloom(cx: int, cy: int, s: float) -> void:
	_blk(cx, cy + 1, center_color.darkened(0.35), s)  # 입체 음영
	_blk(cx, cy - 1, petal_color, s)
	_blk(cx - 1, cy, petal_color, s)
	_blk(cx + 1, cy, petal_color, s)
	_blk(cx, cy, center_color, s)
