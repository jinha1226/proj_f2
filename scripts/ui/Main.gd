extends Control
## 메인 씬 컨트롤러. GameManager 시그널 구독 → 라벨 갱신. 자동 저장.

@onready var _pollen_label: Label = $UI/TopBar/PollenLabel
@onready var _rate_label: Label = $UI/TopBar/RateLabel
@onready var _shop: VBoxContainer = $UI/ShopPanel
@onready var _offline_popup: Panel = $UI/OfflinePopup
@onready var _garden: Node2D = $World/GardenField
@onready var _producers: Node2D = $World/ProducerLayer
@onready var _plant_banner: Panel = $UI/PlantBanner
@onready var _plant_label: Label = $UI/PlantBanner/Label
@onready var _done_btn: Button = $UI/PlantBanner/DoneButton

const AUTOSAVE_INTERVAL := 10.0
const SHOP_ROW := preload("res://scenes/components/ShopRow.tscn")
var _autosave_timer := 0.0
var _rows: Array = []

func _ready() -> void:
	var loaded := SaveManager.load_game(GameManager)
	if loaded:
		var now := int(Time.get_unix_time_from_system())
		var earned := SaveManager.offline_earnings(
			GameManager.per_sec(), SaveManager.last_saved_at, now)
		GameManager.pollen += earned
		_offline_popup.show_earnings(earned)
	# 자식 노드는 이미 _ready를 마쳤으므로(레벨0 기준), 로드된 상태로 다시 맞춘다.
	_garden.sync_from_state()
	_producers.sync_from_state()
	GameManager.pollen_changed.connect(_on_pollen_changed)
	PlantMode.changed.connect(_on_plant_mode_changed)
	_done_btn.pressed.connect(PlantMode.stop)
	_refresh()
	_build_shop()
	_on_plant_mode_changed(PlantMode.active_id)

## 심기 모드 진입/해제 시 배너 토글.
func _on_plant_mode_changed(active_id: String) -> void:
	if active_id == "":
		_plant_banner.hide()
	else:
		_plant_label.text = "🌱 %s 심는 중 — 흙을 탭하세요" % GameData.FLOWERS[active_id]["name"]
		_plant_banner.show()
	_refresh()

func _build_shop() -> void:
	for id in GameData.FLOWERS:
		_add_row("flower", id)
	for id in GameData.PRODUCERS:
		_add_row("producer", id)

func _add_row(kind: String, id: String) -> void:
	var row = SHOP_ROW.instantiate()
	_shop.add_child(row)
	row.setup(kind, id)
	_rows.append(row)

func _on_pollen_changed(_amount: float) -> void:
	_refresh()

func _refresh() -> void:
	_pollen_label.text = "🌸 %d" % int(GameManager.pollen)
	_rate_label.text = "▲ %d/s" % int(GameManager.per_sec())
	for row in _rows:
		row.refresh()

func _process(delta: float) -> void:
	_autosave_timer += delta
	if _autosave_timer >= AUTOSAVE_INTERVAL:
		_autosave_timer = 0.0
		SaveManager.save_game(GameManager, int(Time.get_unix_time_from_system()))

## 앱이 백그라운드로 갈 때 저장.
func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SaveManager.save_game(GameManager, int(Time.get_unix_time_from_system()))
