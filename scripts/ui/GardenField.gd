extends Node2D
## 정원. 꽃 종류별로 정해진 자리에 한 송이씩 심는다.
## upgrade_purchased(id, count) → 해당 꽃 레벨 갱신(레벨1=심기, 그 이상=키우기).

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")

## 꽃밭 중심 위치(화면 좌표). 탑다운 흙밭 안에 흩어 심는다.
const SPOTS := {
	"daisy": Vector2(320, 620),
	"tulip": Vector2(740, 540),
	"rose": Vector2(520, 880),
}
## 종류별 외형: 꽃잎색 / 중심색 / (호환용)꽃잎 수. Tiny Terraces 팔레트.
const STYLE := {
	"daisy": {"petal": Palette.CREAM, "center": Palette.YELLOW, "petals": 8},
	"tulip": {"petal": Palette.ORANGE_L, "center": Palette.ORANGE, "petals": 6},
	"rose": {"petal": Palette.PURPLE_L, "center": Palette.PURPLE, "petals": 12},
}

var _flowers := {}

func _ready() -> void:
	for id in SPOTS:
		var f = FlowerSprite.new()
		f.position = SPOTS[id]
		f.configure(STYLE[id]["petal"], STYLE[id]["center"], STYLE[id]["petals"])
		add_child(f)
		_flowers[id] = f
	GameManager.upgrade_purchased.connect(_on_upgrade)
	sync_from_state()

func _on_upgrade(id: String, count: int) -> void:
	if _flowers.has(id):
		_flowers[id].set_level(count)

## 현재 GameManager 상태(저장 로드 후 포함)로 모든 꽃을 맞춘다.
func sync_from_state() -> void:
	for id in _flowers:
		_flowers[id].set_level(int(GameManager.flower_levels.get(id, 0)))
