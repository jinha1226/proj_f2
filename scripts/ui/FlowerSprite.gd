extends Node2D
## 탑다운 잎 무성한 꽃 덤불(Tiny Terraces식 오리지널). 원점=덤불 밑동.
## 초록 잎 덤불(아래쪽 음영) 위에 작은 꽃송이가 박힌다.
## 레벨이 오를수록 덤불이 커지고 꽃송이가 늘어난다.

const PX := 7.0  # art-pixel 한 칸의 화면 크기

## 꽃송이를 흩어놓을 위치(art-pixel, 덤불 윗부분 기준).
const BLOOM_OFFSETS := [
	Vector2i(0, -1), Vector2i(-2, -2), Vector2i(2, -2), Vector2i(-1, 1),
	Vector2i(2, 1), Vector2i(-3, 0), Vector2i(3, -1), Vector2i(0, -3), Vector2i(1, 3),
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
	var rx: int = 3 + grow / 2          # 덤불 반너비(블록)
	var ry: int = 4 + grow              # 덤불 반높이(위로 무성)
	# 땅 그림자
	draw_rect(Rect2(-rx * s, ry * 0.18 * s, rx * 2 * s, s * 1.1), Color(0, 0, 0, 0.12), true)
	# 잎 덤불(타원, 위쪽만) — 두 톤 + 아래 음영
	for ax in range(-rx, rx + 1):
		for ay in range(-ry, 1):
			var nx := float(ax) / rx
			var ny := float(ay) / ry
			if nx * nx + ny * ny <= 1.0:
				var c: Color = Palette.GREEN if (ax + ay) % 2 == 0 else Palette.LEAF
				if ay >= -1:               # 밑단 음영
					c = Palette.GREEN_DARK
				_blk(ax, ay, c, s)
	# 꽃송이 — 레벨로 개수 증가, 덤불 윗부분에 배치
	var blooms: int = min(1 + grow, BLOOM_OFFSETS.size())
	var lift: int = ry / 2
	for i in range(blooms):
		_draw_bloom(BLOOM_OFFSETS[i].x, BLOOM_OFFSETS[i].y - lift, s)

func _draw_bloom(cx: int, cy: int, s: float) -> void:
	# 외곽 음영(아래) 한 칸으로 입체감
	_blk(cx, cy + 1, center_color.darkened(0.35), s)
	_blk(cx, cy - 1, petal_color, s)
	_blk(cx - 1, cy, petal_color, s)
	_blk(cx + 1, cy, petal_color, s)
	_blk(cx, cy, center_color, s)
