extends Node2D
## 정원. 꽃 종류별로 여러 자리에 심는다. 레벨이 오르면 앞 송이부터 등장/성장하여
## 흙밭을 채운다(레벨1=첫 송이 심기, 그 이상=더 많이/더 크게).

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")

## 꽃 종류별 여러 자리(월드 좌표, 큰 흙밭 전체에 분산).
const SPOTS := {
	"daisy": [Vector2(260, 320), Vector2(460, 720), Vector2(300, 1180), Vector2(520, 1640), Vector2(280, 2200), Vector2(480, 2740), Vector2(360, 3180), Vector2(220, 1900)],
	"tulip": [Vector2(1640, 360), Vector2(1840, 780), Vector2(1560, 1280), Vector2(1820, 1760), Vector2(1600, 2320), Vector2(1840, 2860), Vector2(1700, 3220), Vector2(1560, 600)],
	"rose": [Vector2(980, 900), Vector2(1180, 1480), Vector2(1000, 2080), Vector2(1200, 2680), Vector2(960, 460), Vector2(1240, 3160), Vector2(860, 1760), Vector2(1080, 620)],
}

var _clumps := {}  # id -> Array[FlowerSprite]

## 종류별 외형: 꽃잎색 / 중심색 / (호환용)꽃잎 수. Tiny Terraces 팔레트.
## 다른 스크립트 const는 const 초기화에 못 써서 런타임 생성.
func _style() -> Dictionary:
	return {
		"daisy": {"petal": Palette.CREAM, "center": Palette.YELLOW, "petals": 8},
		"tulip": {"petal": Palette.ORANGE_L, "center": Palette.ORANGE, "petals": 6},
		"rose": {"petal": Palette.PURPLE_L, "center": Palette.PURPLE, "petals": 12},
	}

func _ready() -> void:
	var style := _style()
	for id in SPOTS:
		var arr := []
		for spot in SPOTS[id]:
			var f = FlowerSprite.new()
			f.position = spot
			f.configure(style[id]["petal"], style[id]["center"], style[id]["petals"])
			add_child(f)
			arr.append(f)
		_clumps[id] = arr
	GameManager.upgrade_purchased.connect(_on_upgrade)
	sync_from_state()

## 레벨이 오를수록 앞 송이부터 등장하고, 앞 송이가 더 크게 자란다.
func _apply(id: String, level: int) -> void:
	var arr = _clumps[id]
	for i in arr.size():
		arr[i].set_level(max(0, level - i))

func _on_upgrade(id: String, count: int) -> void:
	if _clumps.has(id):
		_apply(id, count)

## 현재 GameManager 상태(저장 로드 후 포함)로 모든 꽃을 맞춘다.
func sync_from_state() -> void:
	for id in _clumps:
		_apply(id, int(GameManager.flower_levels.get(id, 0)))
