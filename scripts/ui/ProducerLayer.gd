extends Node2D
## 생산기(벌/나비)를 들판에 띄운다. 구매 시 부족분을 스폰하고,
## 저장 로드 후에도 보유 수만큼 보이도록 sync_from_state를 제공한다.

const Bee := preload("res://scripts/ui/Bee.gd")
const BOUNDS := Rect2(120, 150, 1920, 3300)  # 벌이 배회하는 들판 영역(큰 월드)
const MAX_PER_KIND := 8

var _spawned := {"bee": 0, "butterfly": 0}

func _ready() -> void:
	GameManager.producer_purchased.connect(_on_purchased)
	sync_from_state()

func _on_purchased(id: String, count: int) -> void:
	_spawn_up_to(id, count)

## 현재 보유 수(저장 로드 후 포함)만큼 채운다.
func sync_from_state() -> void:
	for id in _spawned:
		_spawn_up_to(id, int(GameManager.producer_counts.get(id, 0)))

func _spawn_up_to(id: String, count: int) -> void:
	while _spawned[id] < count and _spawned[id] < MAX_PER_KIND:
		var b = Bee.new()
		add_child(b)
		b.setup(id, BOUNDS)
		_spawned[id] += 1
