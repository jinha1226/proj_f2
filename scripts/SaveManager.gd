extends Node
## 게임 상태 저장/로드 + 오프라인 적립 계산.

const SAVE_PATH := "user://savegame.json"
const OFFLINE_CAP_SECONDS := 7200  # 최대 2시간치 적립

## GameManager 상태 → 저장용 Dictionary. saved_at은 unix 초.
func to_dict(gm: Node, saved_at: int) -> Dictionary:
	return {
		"pollen": gm.pollen,
		"flower_levels": gm.flower_levels.duplicate(),
		"producer_counts": gm.producer_counts.duplicate(),
		"saved_at": saved_at,
	}

## Dictionary → GameManager 상태 복원.
func apply_dict(gm: Node, d: Dictionary) -> void:
	gm.pollen = float(d.get("pollen", 0.0))
	for id in gm.flower_levels:
		gm.flower_levels[id] = int(d.get("flower_levels", {}).get(id, 0))
	for id in gm.producer_counts:
		gm.producer_counts[id] = int(d.get("producer_counts", {}).get(id, 0))
