extends Control
## 메인 씬 컨트롤러. GameManager 시그널 구독 → 라벨 갱신. 자동 저장.

@onready var _pollen_label: Label = $TopBar/PollenLabel
@onready var _rate_label: Label = $TopBar/RateLabel

const AUTOSAVE_INTERVAL := 10.0
var _autosave_timer := 0.0

func _ready() -> void:
	GameManager.pollen_changed.connect(_on_pollen_changed)
	_refresh()

func _on_pollen_changed(_amount: float) -> void:
	_refresh()

func _refresh() -> void:
	_pollen_label.text = "🌸 %d" % int(GameManager.pollen)
	_rate_label.text = "▲ %d/s" % int(GameManager.per_sec())

func _process(delta: float) -> void:
	_autosave_timer += delta
	if _autosave_timer >= AUTOSAVE_INTERVAL:
		_autosave_timer = 0.0
		SaveManager.save_game(GameManager, int(Time.get_unix_time_from_system()))

## 앱이 백그라운드로 갈 때 저장.
func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SaveManager.save_game(GameManager, int(Time.get_unix_time_from_system()))
