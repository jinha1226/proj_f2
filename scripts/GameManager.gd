extends Node
## 모든 게임 상태의 단일 소유자. 상태 변경은 반드시 이 클래스 메서드로.

signal pollen_changed(amount: float)
signal upgrade_purchased(id: String, count: int)
signal producer_purchased(id: String, count: int)

var pollen: float = 0.0
var flower_levels: Dictionary = {}   # id -> 보유 레벨(구매 횟수)
var producer_counts: Dictionary = {} # id -> 보유 수량

func _ready() -> void:
	reset_state()

## 상태를 초기값으로. 세이브 로드 전/테스트에서 사용.
func reset_state() -> void:
	pollen = 0.0
	flower_levels = {}
	producer_counts = {}
	for id in GameData.FLOWERS:
		flower_levels[id] = 0
	for id in GameData.PRODUCERS:
		producer_counts[id] = 0

## 탭당 획득량 = 1(기본) + 보유한 모든 꽃의 tap_power*레벨 합.
func tap_power() -> int:
	var p := 1
	for id in flower_levels:
		p += GameData.FLOWERS[id]["tap_power"] * flower_levels[id]
	return p

func tap() -> void:
	pollen += tap_power()
	pollen_changed.emit(pollen)

## 다음 1개 가격. 꽃은 base_cost와 현재 레벨로 곡선 계산.
func upgrade_cost(id: String) -> int:
	return GameData.cost_at(GameData.FLOWERS[id]["base_cost"], flower_levels[id])

## 구매 성공 시 true. 잔액 부족이면 false(상태 불변).
func buy_upgrade(id: String) -> bool:
	var cost := upgrade_cost(id)
	if pollen < cost:
		return false
	pollen -= cost
	flower_levels[id] += 1
	pollen_changed.emit(pollen)
	upgrade_purchased.emit(id, flower_levels[id])
	return true
