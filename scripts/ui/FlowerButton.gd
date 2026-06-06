extends TextureButton
## 중앙 꽃. 탭하면 GameManager.tap(). 총 꽃 레벨에 따라 크기 성장(도형 프로토타입).

@onready var _shape: ColorRect = $Shape

func _ready() -> void:
	pressed.connect(_on_pressed)
	GameManager.upgrade_purchased.connect(_on_upgrade)
	_update_visual()

func _on_pressed() -> void:
	GameManager.tap()

func _on_upgrade(_id: String, _count: int) -> void:
	_update_visual()

## 총 꽃 레벨 합으로 크기 결정. 도형 단계: 커지는 사각형.
func _update_visual() -> void:
	var total := 0
	for id in GameManager.flower_levels:
		total += GameManager.flower_levels[id]
	var size: float = 80.0 + min(total, 40) * 6.0  # 80~320px
	_shape.custom_minimum_size = Vector2(size, size)
	_shape.color = Color(1.0, 0.6, 0.8)  # 파스텔 핑크 placeholder
