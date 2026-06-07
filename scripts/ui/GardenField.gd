extends Node2D
## 정원. 꽃을 "여러 번 심어" 흙밭을 채운다. 종류별 심을 자리를 격자로 많이 만들고,
## 그 꽃 보유 수(level)만큼 앞 자리부터 한 송이씩 등장시킨다. 각 송이는 작은 덤불.

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")

const TYPES := ["daisy", "tulip", "rose"]
const COLS := 8
const ROWS := 14
const AREA := Rect2(170, 230, 1840, 3140)  # 심는 영역(월드 좌표)
const CLUMP_MAX := 3                        # 각 송이 최대 성숙도(작게 유지)

var _clumps := {}  # id -> Array[FlowerSprite]  (심을 자리 순서대로)

func _style() -> Dictionary:
	return {
		"daisy": {"petal": Palette.CREAM, "center": Palette.YELLOW, "petals": 8},
		"tulip": {"petal": Palette.ORANGE_L, "center": Palette.ORANGE, "petals": 6},
		"rose": {"petal": Palette.PURPLE_L, "center": Palette.PURPLE, "petals": 12},
	}

func _ready() -> void:
	var style := _style()
	for t in TYPES:
		_clumps[t] = []
	# 흙밭 전체에 격자로 심을 자리 생성(종류 교대 배치 + 결정적 지터로 자연스럽게)
	var k := 0
	for r in range(ROWS):
		for c in range(COLS):
			var t: String = TYPES[k % TYPES.size()]
			var jx := (k * 37 % 70) - 35
			var jy := (k * 53 % 70) - 35
			var x := AREA.position.x + (c + 0.5) * AREA.size.x / COLS + jx
			var y := AREA.position.y + (r + 0.5) * AREA.size.y / ROWS + jy
			var f = FlowerSprite.new()
			f.position = Vector2(x, y)
			f.configure(style[t]["petal"], style[t]["center"], style[t]["petals"])
			f.set_level(0)
			add_child(f)
			_clumps[t].append(f)
			k += 1
	GameManager.upgrade_purchased.connect(_on_upgrade)
	sync_from_state()

## 보유 수만큼 앞 자리부터 한 송이씩 등장(각 송이는 CLUMP_MAX까지 살짝 자람).
func _apply(id: String, count: int) -> void:
	var arr = _clumps[id]
	for i in arr.size():
		arr[i].set_level(clampi(count - i, 0, CLUMP_MAX))

func _on_upgrade(id: String, count: int) -> void:
	if _clumps.has(id):
		_apply(id, count)

func sync_from_state() -> void:
	for id in _clumps:
		_apply(id, int(GameManager.flower_levels.get(id, 0)))
