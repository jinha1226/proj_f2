extends Node2D
## 정원. 플레이어가 흙을 탭한 위치에 꽃을 심는다(심기 모드).
## GameManager.flower_planted(id, pos) → 그 자리에 꽃 한 송이 스폰.
## 저장에서 불러올 때는 GameManager.placed 목록으로 복원.

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")
const PLANTED_LEVEL := 4  # 심은 꽃의 표시 크기(작은 덤불)

func _style() -> Dictionary:
	return {
		"daisy": {"petal": Palette.CREAM, "center": Palette.YELLOW, "petals": 8},
		"tulip": {"petal": Palette.ORANGE_L, "center": Palette.ORANGE, "petals": 6},
		"rose": {"petal": Palette.PURPLE_L, "center": Palette.PURPLE, "petals": 12},
	}

func _ready() -> void:
	GameManager.flower_planted.connect(_on_planted)
	sync_from_state()

func _on_planted(id: String, pos: Vector2) -> void:
	_spawn(id, pos)

func _spawn(id: String, pos: Vector2) -> void:
	var st = _style()[id]
	var f = FlowerSprite.new()
	f.position = pos
	f.configure(st["petal"], st["center"], st["petals"])
	f.set_level(PLANTED_LEVEL)
	add_child(f)

## 현재 상태(저장 로드 후 포함)로 정원을 다시 그린다.
func sync_from_state() -> void:
	for c in get_children():
		c.queue_free()
	for e in GameManager.placed:
		_spawn(str(e[0]), Vector2(e[1], e[2]))
