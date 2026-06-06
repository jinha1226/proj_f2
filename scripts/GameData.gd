extends Node
## 밸런스 데이터 테이블. 로직 없음. 콘텐츠 추가는 여기 딕셔너리에 한 줄.

const PRICE_MULT := 1.15

## 꽃 업그레이드: 사면 탭당 획득량이 tap_power만큼 증가. 순차 해금(unlock_at).
const FLOWERS := {
	"daisy":  {"name": "데이지", "base_cost": 10,   "tap_power": 1,  "unlock_at": 0},
	"tulip":  {"name": "튤립",   "base_cost": 200,  "tap_power": 5,  "unlock_at": 100},
	"rose":   {"name": "장미",   "base_cost": 5000, "tap_power": 40, "unlock_at": 2500},
}

## 자동 생산기: 사면 초당 생산량이 per_sec만큼 증가.
const PRODUCERS := {
	"bee":       {"name": "벌",   "base_cost": 50,   "per_sec": 1,  "unlock_at": 0},
	"butterfly": {"name": "나비", "base_cost": 1000, "per_sec": 20, "unlock_at": 500},
}

## 동일 항목을 count개 보유한 상태에서 다음 1개 가격. 1.15배 지수 곡선.
static func cost_at(base_cost: int, count: int) -> int:
	return int(base_cost * pow(PRICE_MULT, count))
