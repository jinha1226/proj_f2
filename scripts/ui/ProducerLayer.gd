extends Node2D
## 생산기 구매 시 작은 도형을 화면에 추가해 좌우로 떠다니게 함.

const COLORS := {"bee": Color(1, 0.85, 0.2), "butterfly": Color(0.6, 0.4, 1)}
var _spawned := {"bee": 0, "butterfly": 0}

func _ready() -> void:
	GameManager.producer_purchased.connect(_on_purchased)

func _on_purchased(id: String, count: int) -> void:
	# 현재 표시 개수가 보유 수량보다 적으면 부족분 스폰 (최대 8개까지만 시각화)
	while _spawned[id] < count and _spawned[id] < 8:
		_spawn(id)
		_spawned[id] += 1

func _spawn(id: String) -> void:
	var dot := ColorRect.new()
	dot.color = COLORS[id]
	dot.size = Vector2(40, 40)
	# 인덱스 기반 배치(랜덤 미사용): 중앙 위쪽에 가로로 분산
	var i: int = _spawned[id]
	var x: float = 200.0 + (i % 4) * 160.0
	var y: float = 300.0 + (120.0 if id == "butterfly" else 0.0) + (i / 4) * 80.0
	dot.position = Vector2(x, y)
	add_child(dot)
	# 좌우로 부드럽게 떠다니기
	var tw := create_tween().set_loops()
	tw.tween_property(dot, "position:x", x + 30.0, 1.2).set_trans(Tween.TRANS_SINE)
	tw.tween_property(dot, "position:x", x - 30.0, 1.2).set_trans(Tween.TRANS_SINE)
