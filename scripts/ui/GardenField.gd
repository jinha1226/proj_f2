extends Node2D
## 정원. 꽃 종류별로 여러 자리에 심는다. 레벨이 오르면 앞 송이부터 등장/성장하여
## 흙밭을 채운다(레벨1=첫 송이 심기, 그 이상=더 많이/더 크게).

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")

## 꽃 종류별 여러 자리(화면 좌표).
const SPOTS := {
	"daisy": [Vector2(180, 420), Vector2(340, 560), Vector2(200, 760), Vector2(380, 920), Vector2(150, 1060), Vector2(430, 1140)],
	"tulip": [Vector2(620, 400), Vector2(840, 520), Vector2(680, 700), Vector2(900, 860), Vector2(640, 1000), Vector2(860, 1120)],
	"rose": [Vector2(500, 520), Vector2(540, 780), Vector2(300, 650), Vector2(760, 940), Vector2(480, 980), Vector2(720, 620)],
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
