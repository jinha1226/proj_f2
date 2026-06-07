extends Node2D
## 정원. 심기 모드에서 흙을 탭하면 가장 가까운 타일에 스냅해 심는다(한 타일 한 송이).
## GameManager.flower_planted(id, pos) → 그 자리에 꽃 스폰. 저장에서 placed로 복원.

const FlowerSprite := preload("res://scripts/ui/FlowerSprite.gd")
const PLANTED_LEVEL := 4  # 심은 꽃의 표시 크기

var _occupied := {}  # Vector2i 타일 -> true

func _style() -> Dictionary:
	return {
		"daisy": {"petal": Palette.CREAM, "center": Palette.YELLOW, "petals": 8},
		"tulip": {"petal": Palette.ORANGE_L, "center": Palette.ORANGE, "petals": 6},
		"rose": {"petal": Palette.PURPLE_L, "center": Palette.PURPLE, "petals": 12},
	}

func _ready() -> void:
	GameManager.flower_planted.connect(_on_planted)
	sync_from_state()

## 카메라가 호출: 탭 위치를 타일에 스냅해 심기. 범위 밖/이미 찬 타일이면 false.
func try_plant(id: String, world_pos: Vector2) -> bool:
	var c := Grid.cell(world_pos)
	if not Grid.in_bounds(c) or _occupied.has(c):
		return false
	return GameManager.plant_flower(id, Grid.center(c))

func _on_planted(id: String, pos: Vector2) -> void:
	_spawn(id, pos)
	_occupied[Grid.cell(pos)] = true

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
	_occupied = {}
	for e in GameManager.placed:
		var pos := Vector2(e[1], e[2])
		_spawn(str(e[0]), pos)
		_occupied[Grid.cell(pos)] = true
