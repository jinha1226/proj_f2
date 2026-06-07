extends Button
## 상점 한 줄. kind="flower" 또는 "producer", id=항목 키.
## 누르면 해당 구매 메서드 호출. 가격/레벨을 라벨에 표시.

var kind: String
var id: String

func setup(p_kind: String, p_id: String) -> void:
	kind = p_kind
	id = p_id
	pressed.connect(_on_pressed)
	refresh()

func _on_pressed() -> void:
	if kind == "flower":
		PlantMode.start(id)   # 심기 모드 진입 → 흙을 탭해 심는다
	else:
		GameManager.buy_producer(id)
	# 구매/선택 후 갱신은 Main이 전체 refresh로 처리

func refresh() -> void:
	var data
	var count: int
	var cost: int
	if kind == "flower":
		data = GameData.FLOWERS[id]
		count = GameManager.flower_levels[id]
		cost = GameManager.upgrade_cost(id)
	else:
		data = GameData.PRODUCERS[id]
		count = GameManager.producer_counts[id]
		cost = GameManager.producer_cost(id)
	visible = GameManager.pollen >= data["unlock_at"] or count > 0
	if kind == "flower":
		if count == 0:
			text = "🌱 %s 심기      🌸%d" % [data["name"], cost]
		else:
			text = "🌱 %s 더 심기 (%d송이)      🌸%d" % [data["name"], count, cost]
	else:
		text = "%s 늘리기 (보유 %d)      🌸%d" % [data["name"], count, cost]
	disabled = GameManager.pollen < cost
