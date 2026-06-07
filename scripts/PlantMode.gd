extends Node
## 심기 모드 상태. 상점에서 꽃을 고르면 active_id가 설정되고,
## 흙을 탭하면 그 꽃을 심는다. 완료하면 해제.

signal changed(active_id: String)

var active_id: String = ""

func start(id: String) -> void:
	active_id = id
	changed.emit(active_id)

func stop() -> void:
	active_id = ""
	changed.emit(active_id)

func is_active() -> bool:
	return active_id != ""
