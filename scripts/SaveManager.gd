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

var last_saved_at: int = 0

## 오프라인 적립. per_sec * 경과초, 단 [0, CAP]로 클램프.
func offline_earnings(rate: float, saved_at: int, now: int) -> float:
	if rate <= 0.0:
		return 0.0
	var elapsed := now - saved_at
	elapsed = clampi(elapsed, 0, OFFLINE_CAP_SECONDS)
	return rate * elapsed

func save_game(gm: Node, saved_at: int) -> void:
	last_saved_at = saved_at
	var d := to_dict(gm, saved_at)
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(d))
	f.close()

## 저장 파일이 있으면 상태 복원 후 true. 없으면 false.
func load_game(gm: Node) -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text := f.get_as_text()
	f.close()
	var d = JSON.parse_string(text)
	if typeof(d) != TYPE_DICTIONARY:
		return false
	apply_dict(gm, d)
	last_saved_at = int(d.get("saved_at", 0))
	return true
