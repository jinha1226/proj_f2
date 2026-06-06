extends TextureButton
## 중앙 꽃. 탭하면 GameManager.tap(). 총 꽃 레벨에 따라 크기 성장(도형 프로토타입).

const FLOATING := preload("res://scenes/FloatingText.tscn")

@onready var _shape: ColorRect = $Shape

func _ready() -> void:
	pressed.connect(_on_pressed)
	GameManager.upgrade_purchased.connect(_on_upgrade)
	_update_visual()

func _on_pressed() -> void:
	var gained := GameManager.tap_power()
	GameManager.tap()
	var ft = FLOATING.instantiate()
	get_tree().current_scene.add_child(ft)
	ft.show_amount(gained, global_position + size * 0.5)

func _on_upgrade(_id: String, _count: int) -> void:
	_update_visual()

## 총 꽃 레벨 합으로 크기 결정. 도형 단계: 커지는 사각형.
func _update_visual() -> void:
	var total := 0
	for id in GameManager.flower_levels:
		total += GameManager.flower_levels[id]
	var size: float = 80.0 + min(total, 40) * 6.0  # 80~320px
	# Shape는 중앙 앵커(0.5)이므로 오프셋을 ±절반으로 줘서 중앙 유지하며 리사이즈.
	var half: float = size * 0.5
	_shape.offset_left = -half
	_shape.offset_top = -half
	_shape.offset_right = half
	_shape.offset_bottom = half
	_shape.color = Color(1.0, 0.6, 0.8)  # 파스텔 핑크 placeholder
